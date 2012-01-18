class RenameStoryRatingsToRatings < ActiveRecord::Migration
  def self.up
    rename_table :story_ratings, :ratings
  end

  def self.down
    rename_tabe :ratings, :story_ratings
  end
end
