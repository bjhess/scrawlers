class MakeStoryRatingsRateable < ActiveRecord::Migration
  def self.up
    add_column :story_ratings, :rating, :integer, :default => 0
    add_column :story_ratings, :rateable_type, :string, :limit => 15,
                               :default => "", :null => false
    add_column :story_ratings, :rateable_id, :integer,
                               :default => 0, :null => false

    remove_column :story_ratings, :vote

    add_index :story_ratings, ["user_id"], :name => "fk_story_ratings_user"
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration
  end
end
