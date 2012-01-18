class CreateStoryViews < ActiveRecord::Migration
  def self.up
    create_table :story_views do |t|
      t.column :story_id, :integer
      t.column :created_at, :datetime
    end
  end

  def self.down
    drop_table :story_views
  end
end
