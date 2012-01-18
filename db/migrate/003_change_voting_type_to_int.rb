class ChangeVotingTypeToInt < ActiveRecord::Migration
  def self.up
    change_column :stories, :votes, :integer
    change_column :stories, :score, :integer
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration
  end
end
