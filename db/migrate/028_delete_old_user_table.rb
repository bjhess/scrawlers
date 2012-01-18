class DeleteOldUserTable < ActiveRecord::Migration
  def self.up
    drop_table "users"
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration
  end
end
