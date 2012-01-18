class RemoveStoryIdFromUser < ActiveRecord::Migration
  def self.up
    remove_column :users, :story_id
  end

  def self.down
    add_column :users, :story_id, :integer
  end
end
