class CreateRoles < ActiveRecord::Migration
  def self.up
    create_table :roles_users, :id => false do |t|
      t.column "role_id", :integer
      t.column "user_id", :integer
    end

    create_table :roles do |t|
      t.column "name", :string
    end
  end

  def self.down
    drop_table :roles_users
    drop_table :roles
  end
end
