class CreateStoryReadings < ActiveRecord::Migration
  def self.up
    create_table :story_readings do |t|
      t.column :story_id, :integer
      t.column :user_id, :integer
      t.column :vote, :integer
      t.column :timestamp, :datetime
    end
  end

  def self.down
    drop_table :story_readings
  end
end
