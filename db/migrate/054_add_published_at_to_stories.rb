class AddPublishedAtToStories < ActiveRecord::Migration
  def self.up
    add_column :stories, :published_at, :datetime
    Story.transaction do
      Story.find(:all).each do |story|
        story.update_attribute(:published_at, story.created_at)
      end
    end
  end

  def self.down
    remove_column :stories, :published_at
  end
end
