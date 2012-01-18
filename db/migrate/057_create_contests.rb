class CreateContests < ActiveRecord::Migration
  def self.up
    create_table :contests, :force => true do |t|
      t.string :title, :tag_name, :prize_link, :image_link, :null => false
      t.text :description, :null => false
      t.datetime :start_time, :end_time, :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :contests
  end
end
