class AddCreatedAtFieldToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :created_at, :datetime
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration
  end
end
