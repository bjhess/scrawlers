class DropRightsAndRolesTables < ActiveRecord::Migration
  def self.up
    drop_table :rights
    drop_table :rights_roles
    drop_table :roles
    drop_table :roles_users
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration
  end
end
