class CreateStories < ActiveRecord::Migration
  def self.up
    create_table :stories do |t|
      t.column :title, :string
      t.column :body, :text
      t.column :timestamp, :datetime
      t.column :votes, :long
      t.column :score, :long
    end
  end

  def self.down
    drop_table :stories
  end
end
