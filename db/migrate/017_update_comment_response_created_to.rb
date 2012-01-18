class UpdateCommentResponseCreatedTo < ActiveRecord::Migration
  def self.up
    rename_column :comment_responses, :create_at, :created_at
  end

  def self.down
    rename_column :comment_responses, :created_at, :create_at
  end
end
