class RenameStoryReadingsToStoryRatings < ActiveRecord::Migration
  def self.up
    rename_table :story_readings, :story_ratings
  end

  def self.down
    rename_tabe :story_ratings, :story_readings
  end
end
