class CreateComments < ActiveRecord::Migration
  def self.up
    create_table :comments do |t|
      t.column :story_id, :integer
      t.column :user_id, :integer
      t.column :body, :text
      t.column :timestamp, :datetime
    end
  end

  def self.down
    drop_table :comments
  end
end
