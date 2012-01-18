class ChangeResponseTableToCommentResponse < ActiveRecord::Migration
  def self.up
    rename_table :responses, :comment_responses
  end

  def self.down
    rename_table :comment_responses, :responses
  end
end
