class RenameCommentReadingsToCommentRatings < ActiveRecord::Migration
  def self.up
    rename_table :comment_readings, :comment_ratings
  end

  def self.down
    rename_table :comment_ratings, :comment_readings
  end
end
