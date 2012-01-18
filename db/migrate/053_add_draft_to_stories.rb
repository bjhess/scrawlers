class AddDraftToStories < ActiveRecord::Migration
  def self.up
    add_column :stories, :draft, :boolean, :default => false
  end

  def self.down
    remove_column :stories, :draft
  end
end
