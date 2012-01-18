class CreateNotifications < ActiveRecord::Migration
  def self.up
    create_table :notifications do |t|
      t.column :message, :string
      t.column :url, :string
      t.column :created_at, :datetime
    end
    
    add_column :users, :last_notification_id, :integer
    users = User.find(:all)
    users.each do |user|
      user.update_attributes(:last_notification_id => 0)
    end
  end

  def self.down
    drop_table :notifications
    remove_column :users, :last_notification_id
  end
end
