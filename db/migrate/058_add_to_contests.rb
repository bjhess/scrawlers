class AddToContests < ActiveRecord::Migration
  def self.up
    add_column :contests, :first_place_id, :integer
    add_column :contests, :prize_title, :string, :null => false
  end

  def self.down
    remove_column :contests, :prize_title
    remove_column :contests, :first_place_id
  end
end
