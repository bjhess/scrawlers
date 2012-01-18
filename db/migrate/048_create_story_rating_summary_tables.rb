class CreateStoryRatingSummaryTables < ActiveRecord::Migration
  
  TABLE_LIST = [:weekly_story_rating_totals, :monthly_story_rating_totals, :all_time_story_rating_totals]
  
  def self.up
    TABLE_LIST.each do |table|
      create_table table do |t|
        t.column :story_id, :integer
        t.column :rating, :decimal, :precision => 3, :scale => 2
        t.column :count, :integer
      end
    end
  end

  def self.down
    TABLE_LIST.each do |table|
      drop_table table
    end
  end
end
