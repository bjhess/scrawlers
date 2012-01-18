class RemoveRatingsData < ActiveRecord::Migration
  def self.up
    drop_table :all_time_story_rating_totals
    drop_table :monthly_story_rating_totals
    drop_table :weekly_story_rating_totals
    drop_table :comment_ratings
    drop_table :ratings
  end

  def self.down
    create_table "ratings", :force => true do |t|
      t.integer  "user_id"
      t.datetime "created_at"
      t.integer  "rating",                      :default => 0
      t.string   "rateable_type", :limit => 15, :default => "", :null => false
      t.integer  "rateable_id",                 :default => 0,  :null => false
    end
    
    create_table "comment_ratings", :force => true do |t|
      t.integer  "comment_id"
      t.integer  "user_id"
      t.integer  "vote"
      t.datetime "created_at"
    end
    
    create_table "weekly_story_rating_totals", :force => true do |t|
      t.integer "story_id"
      t.decimal "rating",   :precision => 3, :scale => 2
      t.integer "count"
    end
    
    create_table "monthly_story_rating_totals", :force => true do |t|
      t.integer "story_id"
      t.decimal "rating",   :precision => 3, :scale => 2
      t.integer "count"
    end
    
    create_table "all_time_story_rating_totals", :force => true do |t|
      t.integer "story_id"
      t.decimal "rating",   :precision => 3, :scale => 2
      t.integer "count"
    end
    
  end
end
