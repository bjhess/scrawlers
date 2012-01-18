class DropNotificationsTable < ActiveRecord::Migration
  def self.up
    drop_table :notifications
  end

  def self.down
    create_table "notifications", :force => true do |t|
      t.string   "message"
      t.string   "url"
      t.datetime "created_at"
    end
    
  end
end
