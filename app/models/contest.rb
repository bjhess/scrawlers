class Contest < ActiveRecord::Base
  belongs_to :first_place_story, :class_name => 'Story', :foreign_key => 'first_place_id'

  class << self
    def find_active_contest
      now = Time.now
      find(:first, :conditions => ["start_time <= ? and end_time >= ?", now, now])
    end

    def find_all_past_contests
      find(:all, :conditions => ["end_time < ?", Time.now], :order => "end_time DESC")
    end
  end

  ##
  # This actually breaks down when there are four stories.  Only returns two filled arrays.
  def entered_stories_in_thirds
    count = (entered_stories.size/3.0).ceil
    return entered_stories.first!(count), entered_stories.first!(count), entered_stories.first!(count)
  end
  
  def entered_stories_in_twos
    count = (entered_stories.size/2.0).ceil
    return entered_stories.first!(count), entered_stories.first!(count)
  end
  
  ##
  # Includes stories and notes on stories. Technically one story per day and one note per story.
  # Only checking the note bit for now.
  def entry_user_ids
    (entered_stories.map(&:user_id) + entered_notes_user_ids).flatten
  end

  private

    def entered_stories
      return @entered_stories if @entered_stories
      tag = Tag.find_by_name(tag_name)
      @entered_stories = tag ? tag.tagged.compact.select{|s| s.created_at.between?(start_time, end_time)}.sort_by(&:created_at).reverse : []
    end
    
    def entered_notes_user_ids
      notes_user_ids = []
      entered_stories.each{|s| notes_user_ids << s.notes.map(&:user_id).uniq}
      return notes_user_ids.flatten
    end

end
