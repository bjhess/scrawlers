class AddUserIdToStoryView < ActiveRecord::Migration
  def self.up
    add_column :story_views, :user_id, :integer
  end

  def self.down
    remove_column :story_views, :user_id
  end
end
