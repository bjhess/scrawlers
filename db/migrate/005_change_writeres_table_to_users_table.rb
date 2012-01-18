class ChangeWriteresTableToUsersTable < ActiveRecord::Migration
  def self.up
    rename_table :writers, :users
  end

  def self.down
    rename_table :users, :writers
  end
end
