class AddPasswordToWriters < ActiveRecord::Migration
  def self.up
    add_column :writers, :hashed_password, :string
    add_column :writers, :salt, :string
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration
  end
end
