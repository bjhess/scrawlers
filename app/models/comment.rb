class Comment < ActiveRecord::Base
  belongs_to :story
  belongs_to :user
  belongs_to :parent, :class_name => 'Comment', :foreign_key => :parent_id
  has_one :response, :class_name => 'Comment', :foreign_key => :parent_id  # like a child
  validates_presence_of :body

  named_scope :not_responses, :conditions => "parent_id is null"
  named_scope :responses, :conditions => "parent_id is not null"
  named_scope :limited, lambda { |num| {:limit => num} }
  named_scope :ordered, lambda { |*order| { :order => order.flatten.first || 'created_at DESC' } }

  # Protects any additional parameters from malicious population
  # via forms.  See section 26.2 in Rails book for more details.
  attr_accessible :body
  
  class << self
    def notes
      self.find(:all, :conditions => 'parent_id IS NULL')
    end
  
    def find_notes_by_user_id(user_id, limit = 10000)
      self.find_all_by_user_id(user_id,
                               :conditions => "parent_id IS NULL",
                               :limit => limit,
                               :order => "created_at DESC")
    end
  
    def find_all_by_story_id_sorted(story_id, limit=50)
      self.find_all_by_story_id(story_id,
                                :order => 'created_at DESC',
                                :limit => limit)
    end
  
    def find_most_recent_time_by_story_id(story_id)
      most_recent = self.find_all_by_story_id(story_id,
                                              :order => 'created_at DESC').first
    
      most_recent ? most_recent.created_at : Date.new(2007, 1, 1).to_time
    end
  
    def find_recent(number_of_comments=50)
      find(:all, :limit => number_of_comments, :order => "created_at DESC")
    end

    def latest_paged(page, limit=nil)
      find(:all,
           :limit => limit,
           :order => "created_at DESC",
           :page  => { :size => PAGE_SIZE, :current => page })
    end
  
    def responses
      find(:all, :conditions => 'parent_id IS NOT NULL')
    end
  end
  
  def is_response?
    !self.parent_id.nil?
  end
  
  def has_response?
    !self.response.nil?
  end
  
  def is_note?
    self.parent_id.nil?    
  end
    
end
