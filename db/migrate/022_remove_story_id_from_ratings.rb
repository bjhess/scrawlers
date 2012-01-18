class RemoveStoryIdFromRatings < ActiveRecord::Migration
  def self.up
    remove_column :ratings, :story_id
  end

  def self.down
    add_column :ratings, :story_id, :integer, :default => 0, :null => false
  end
end
