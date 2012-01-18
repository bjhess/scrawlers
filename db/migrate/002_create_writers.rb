class CreateWriters < ActiveRecord::Migration
  def self.up
    create_table :writers do |t|
      t.column :username, :string
      t.column :email, :string
      t.column :story_id, :integer
    end
  end

  def self.down
    drop_table :writers
  end
end
