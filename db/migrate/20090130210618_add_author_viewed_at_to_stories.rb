class AddAuthorViewedAtToStories < ActiveRecord::Migration
  def self.up
    add_column :stories, :author_viewed_at, :timestamp
    Story.find(:all).each do |story|
      story.update_attribute(:author_viewed_at, Time.now)
    end
  end

  def self.down
    remove_column :stories, :author_viewed_at
  end
end
