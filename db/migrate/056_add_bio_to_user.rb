class AddBioToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :bio, :string, :limit => 100
  end

  def self.down
    remove_column :users, :bio
  end
end
