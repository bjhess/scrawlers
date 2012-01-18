require 'digest/sha1'
class User < ActiveRecord::Base
  # Virtual attribute for the unencrypted password
  attr_accessor :password
  
  has_many :stories, :order => 'published_at DESC' do
    def recent(number_of_stories=10, reload=false)
      @recent_stories   = nil if reload
      @recent_stories ||= find_recent(number_of_stories)
    end
    def more_than?(number_of_stories)
      @more_than_stories ||= count(:all, :limit => number_of_stories+1) > number_of_stories
    end
  end
  has_many :comments, :order => 'created_at DESC'
  has_many :notes, :class_name => 'Comment', :conditions => 'parent_id IS NULL', :order => 'created_at DESC' do
    def recent(number_of_notes=5, reload=false)
      @recent_notes   = nil if reload
      @recent_notes ||= find_recent(number_of_notes)
    end
    def more_than?(number_of_notes)
      @more_than_notes ||= count(:all, :limit => number_of_notes+1) > number_of_notes
    end
  end
  has_many :responses, :class_name => 'Comment', :conditions => 'parent_id IS NOT NULL', :order => 'created_at DESC'
  has_many :received_notes, :through => :stories, 
                            :source => :notes,
                            :conditions => 'parent_id IS NULL',
                            :order => 'created_at DESC'
  has_many :story_views
  has_many :invitations
  has_many :favoriteds, :as => :favoritable, :class_name => 'Favorite'
  has_many :fans, :through => :favoriteds, :source => :user, :order => 'display_name'
  has_many :favorites
  has_many :favorite_authors, :through => :favorites, :source => :favoritable, :source_type => 'User',  :order => 'display_name'
  has_many :favorite_stories, :through => :favorites, :source => :favoritable, :source_type => 'Story', :order => 'favorites.created_at DESC' do
    def latest(number_of_stories=10)
      find(:all, :limit => number_of_stories)
    end
  end
  
  named_scope :ordered, lambda { |*order| { :order => order.flatten.first || 'created_at DESC' } }

  validates_presence_of     :email, :display_name
  validates_presence_of     :password,                   :if => :password_required?
  validates_presence_of     :password_confirmation,      :if => :password_required?
  validates_length_of       :password, :within => 6..40, :if => :password_required?
  validates_confirmation_of :password,                   :if => :password_required?
  validates_length_of       :email,        :within => 6..100
  validates_length_of       :new_email,    :within => 6..100, :if => :new_email_entered?
  validates_length_of       :display_name, :within => 3..50
  validates_length_of       :bio,          :within => 1..100, :if => :has_bio?
  validates_uniqueness_of   :email, :display_name, :case_sensitive => false
  # regex taken from: http://dev.rubyonrails.org/attachment/ticket/2081/validations_email.patch
  validates_format_of       :email,
                            :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/
  validates_format_of       :new_email,
                            :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/,
                            :if => :new_email_entered?
  # regex taken from: http://www.juixe.com/techknow/index.php/2006/07/29/rails-model-validators/
  validates_format_of       :display_name, 
                            :with => /^\w+$/i,
                            :message => "can only contain letters and numbers."
  validates_format_of       :password, 
                            :with => /^\w+$/i,
                            :message => "can only contain letters and numbers.",
                            :if => :password_required?
  before_save   :encrypt_password
  before_create :make_activation_code

  class << self
    # Authenticates a user by their email and unencrypted password.  Returns the user or nil.
    def authenticate(email, password)
      u = find_by_email(email) # need to get the salt
      u && u.authenticated?(password) ? u : nil
    end

    # Encrypts some data with the salt.
    def encrypt(password, salt)
      Digest::SHA1.hexdigest("--#{salt}--#{password}--")
    end
    
    def stale_users
      last_month = Time.now.last_month
      find(:all,
           :select     => "users.email, MAX(stories.created_at) AS story_created_at, MAX(comments.created_at) AS comment_created_at",
           :include    => [:stories, :notes],
           :conditions => ["MAX(stories.created_at) > ? AND MAX(comments.created_at) > ? ", last_month, last_month])
    end
  end
  

  # Assures that updated email addresses do not conflict with
  # existing email addresses.
  def validate
    if User.find_by_email(new_email)
      errors.add(:new_email, "has already been taken")
    end
  end
    
  # Activates the user in the database.
  def activate
    @activated = true
    update_attributes(:activated_at => Time.now.utc, :activation_code => nil)
  end
  
  def activated?
    self.activation_code.blank? && !self.activated_at.blank?
  end
  
  # Activates the changing of a user's email address.
  def activate_new_email
    @activated_email = true
    update_attributes(:email => self.new_email,
                      :new_email => nil,
                      :email_activation_code => nil)
  end

  def authenticated?(password)
    crypted_password == encrypt(password) && self.activated?
  end
  
  # Kick off the process of changing a user's email address
  def change_email_address(new_email_address)
    @change_email = true
    self.new_email = new_email_address
    self.make_email_activation_code
  end
  
  # Encrypts the password with the user salt
  def encrypt(password)
    self.class.encrypt(password, salt)
  end
  
  def forget_me
    self.remember_token_expires_at = nil
    self.remember_token            = nil
    save(false)
  end
  
  def forgot_password
    @forgotten_password = true
    self.make_password_reset_code    
  end
  
  def is_same_user?(user)
    user && self == user
  end
  
  # Returns true if the user has just been activated.
  def recently_activated?
    @activated
  end
  
  # Returns true if the user has recently activated an email address change.
  def recently_activated_email?
    @activated_email    
  end
  
  # Returns true if the user has recently changed his email address.
  def recently_changed_email?
    @change_email
  end
  
  def recently_reset_password?
    @reset_password
  end
  
  def recently_forgot_password?
    @forgotten_password
  end
  
  def remember_token?
    remember_token_expires_at && Time.now.utc < remember_token_expires_at 
  end

  # These create and unset the fields required for remembering users between browser closes
  def remember_me
    self.remember_token_expires_at = 2.weeks.from_now.utc
    self.remember_token            = encrypt("#{email}--#{remember_token_expires_at}")
    save(false)
  end
  
  def reset_password
    # First update the password_reset_code before setting the 
    # reset_password flag to avoid duplicate email notifications.
    update_attributes(:password_reset_code => nil)
    @reset_password = true    
  end
  
  def most_recent_received_note_time
    self.received_notes.empty? ? Time.parse('2007-1-1') : self.received_notes.first.created_at
  end

  # TODO: This method is inefficient.  It makes number_of_stories + 1 calls to the DB.  I tried eager loading
  # of the stories objects, but then the DISTINCT story_id didn't function properly and duplicate stories
  # were retrieved.
  def find_recently_commented_upon_stories(number_of_stories=10)
    Comment.find(:all,
                 :select => "DISTINCT story_id",
                 :conditions => ["user_id=?", self.id],
                 :order => "created_at DESC",
                 :limit => number_of_stories).map(&:story)
  end
  
  # Override to achieve id-display_name urls.
  def to_param
    "#{self.id}-#{self.display_name}"
  end
  
  def is_favorite_story?(story)
    self.favorite_stories.exists?(:id => story.id)
  end
  
  def find_favorite_for_story(story)
    self.favorites.find(:first, :conditions => {:favoritable_id => story.id, :favoritable_type => "Story"})
  end

  def is_favorite_author?(author)
    self.favorite_authors.exists?(:id => author.id)
  end
  
  def find_favorite_for_author(author)
    self.favorites.find(:first, :conditions => {:favoritable_id => author.id, :favoritable_type => "User"})
  end
  
  def has_bio?
    !self.bio.blank?
  end
  
  def bio_or_default
    return self.bio if self.has_bio?
    "If #{self.display_name} had entered a bio, you'd be reading it right now."
  end
  
  def favorite_author_stories(limit=5)
    favorite_author_ids = favorite_authors.find(:all, :select => "users.id").map(&:id)
    Story.ordered.limited(limit).find(:all, :conditions => {:user_id => favorite_author_ids})
  end
  
  def favorite_story_notes(limit=5)
    favorite_story_ids = favorite_stories.find(:all, :select => "stories.id").map(&:id)
    Comment.ordered.limited(limit).find(:all, :conditions => ["story_id in (?) and user_id != ?", favorite_story_ids, self.id])
  end

  protected

    def create_activation_code
      Digest::SHA1.hexdigest( Time.now.to_s.split(//).sort_by {rand}.join )
    end
    # before filter 
    def encrypt_password
      return if password.blank?
      self.salt = Digest::SHA1.hexdigest("--#{Time.now.to_s}--#{email}--") if new_record?
      self.crypted_password = encrypt(password)
    end

    def make_activation_code
      self.activation_code = create_activation_code
    end
    
    def make_email_activation_code
      self.email_activation_code = create_activation_code
    end
    
    def make_password_reset_code
      self.password_reset_code = create_activation_code
    end
    
    def new_email_entered?
      !self.new_email.blank?
    end
    
    def password_required?
      crypted_password.blank? || !password.blank?
    end
end
