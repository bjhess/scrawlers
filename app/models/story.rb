class Story < ActiveRecord::Base
  acts_as_taggable

  belongs_to :user
  has_many :notes, :class_name => 'Comment', :conditions => 'parent_id IS NULL'
  has_many :responses, :class_name => 'Comment', :conditions => 'parent_id IS NOT NULL'
  has_many :story_commentators, :through => :comments, :source => :user
  has_many :invitations
  has_many :favoriteds, :as => :favoritable, :class_name => 'Favorite'
  has_many :fans, :through => :favoriteds, :source => :user

  named_scope :excluding, lambda { |story| {:conditions => ['id != ?', story.id]} }
  named_scope :limited, lambda { |num| {:limit => num} }
  named_scope :ordered, lambda { |*order| { :order => order.flatten.first || 'created_at DESC' } }
  
  before_create :set_published_date

  validates_presence_of :title, :body, :user_id
  validates_length_of :title, :within => 1..40

  # Protects any additional parameters from malicious population
  # via forms.  See section 26.2 in Rails book for more details.
  attr_accessible :title, :body, :tag_string

  # Virtual storage for passing tags through on story writing
  # page.  If there is an error, this will help to retain tag
  # values the author entered.
  attr_accessor :tag_string
  
  class << self
    def featured
      find(:all, :limit => 20, :order => 'published_at DESC')[rand(20)]
    end
    
    def find_all_by_user_id_sorted(user_id, limit=50)
      find_all_by_user_id(user_id,
                          :order => 'updated_at DESC, published_at DESC',
                          :limit => limit)
    end
  
    def find_most_recent_time_by_user_id(user_id)
      most_recent = find_all_by_user_id(user_id,
                                        :order => 'updated_at DESC',
                                        :limit => 1).first
      most_recent ? most_recent.updated_at : Date.new(2007, 1, 1).to_time
    end

    def find_recent(number_of_stories=50)
      find(:all, :limit => number_of_stories, :order => "published_at DESC")
    end
  
    def find_recent_excluding_user(user_id, number_of_stories=50)
      find(:all, 
           :conditions => ["user_id != ?", user_id],
           :limit => number_of_stories, 
           :order => "published_at DESC")
    end
    
    def latest(limit=10)
      find(:all, :limit => limit, :order => "published_at DESC")
    end
    
    def latest_paged(page, limit=nil)
      find(:all,
           :limit => limit,
           :order => "published_at DESC",
           :page  => { :size => PAGE_SIZE, :current => page })
    end
    
    ##
    # Purposely not enforcing sorting order.  This method expects sort to be defined externally.
    def paged(page, params={})
      find(:all, params.merge(:page => {:size => PAGE_SIZE, :current => page}))
    end
  end
  
  def allow_editing?(user)
    self.user.is_same_user?(user) && self.notes.empty?
  end

  def delete_tag(tagname)
    # I added the tag_list_array to the acts_as_taggable plugin
    tags = self.tag_list_array
    tags.delete(tagname)
    self.tag_with(tags.collect { |tag| tag.include?(" ") ? '"' +"#{tag}" + '"' : tag }.join(" "))
    self.save
  end
  
  def number_of_comments_since_last_view
    self.notes.count(:all, :conditions => ["created_at > ? AND parent_id IS NULL", self.author_viewed_at])
  end
  
  def author?(user)
    self.user_id == user.id
  end

 protected

  def validate
    word_count = body.nil? ? 0 : word_count = body.scan(/(\w|-)+/).size
    errors.add(:body, 
               "should not be over 100 words.  " +
               "You have written <span class='highlight'>#{word_count} words</span>.") if word_count > 100
  end
  
  def set_published_date
    self.published_at = Time.now
  end

end
