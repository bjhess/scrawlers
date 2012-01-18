class CreateResponses < ActiveRecord::Migration
  def self.up
    create_table :responses do |t|
      t.column :comment_id, :integer
      t.column :body, :text
      t.column :create_at, :datetime
    end
  end

  def self.down
    drop_table :responses
  end
end
