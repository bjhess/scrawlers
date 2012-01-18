class AddUpdatedAtToStories < ActiveRecord::Migration
  def self.up
    add_column :stories, :updated_at, :datetime
    stories = Story.find(:all)
    for story in stories
      story.update_attributes(:updated_at => story.created_at)
    end
  end

  def self.down
    remove_column :stories, :updated_at
  end
end
