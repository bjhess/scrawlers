class RenameTimestampFieldsToCreatedAt < ActiveRecord::Migration
  def self.up
    rename_column :stories, :timestamp, :created_at
    rename_column :comments, :timestamp, :created_at
    rename_column :story_readings, :timestamp, :created_at
    rename_column :comment_readings, :timestamp, :created_at
  end

  def self.down
    rename_column :stories, :created_at, :timestamp
    rename_column :comments, :created_at, :timestamp
    rename_column :story_readings, :created_at, :timestamp
    rename_column :comment_readings, :created_at, :timestamp
  end
end
