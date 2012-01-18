class RemoveStoryViewsTable < ActiveRecord::Migration
  def self.up
    drop_table :story_views
  end

  def self.down
    create_table "story_views", :force => true do |t|
      t.integer  "story_id"
      t.datetime "created_at"
      t.integer  "user_id"
    end
    
  end
end
