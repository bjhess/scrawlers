class FixTaggableIdColumnName < ActiveRecord::Migration
  def self.up
    rename_column :taggings, :taggale_id, :taggable_id
  end

  def self.down
    rename_column :taggings, :taggable_id, :taggale_id
  end
end
