class RemoveVotingFromStory < ActiveRecord::Migration
  def self.up
    remove_column :stories, :votes
    remove_column :stories, :score
  end

  def self.down
    add_column :stories, :votes, :integer
    add_column :stories, :score, :integer
  end
end
