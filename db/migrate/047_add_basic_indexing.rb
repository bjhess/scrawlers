class AddBasicIndexing < ActiveRecord::Migration
  def self.up
    add_index :comment_responses, :comment_id
    add_index :comments, :created_at
    add_index :comments, :story_id
    add_index :comments, :user_id
    add_index :questions, :faq_section_id
    add_index :ratings, :created_at
    add_index :ratings, [:rateable_id, :user_id, :rateable_type]
    add_index :stories, :user_id
    add_index :stories, :created_at
    add_index :story_views, :created_at
    add_index :story_views, [:story_id, :user_id]
    add_index :taggings, [:taggable_id, :taggable_type]
    add_index :taggings, :tag_id
  end

  def self.down
    remove_index :comment_responses, :comment_id
    remove_index :comments, :created_at
    remove_index :comments, :story_id
    remove_index :comments, :user_id
    remove_index :questions, :faq_section_id
    remove_index :ratings, :created_at
    remove_index :ratings, [:rateable_id, :user_id, :rateable_type]
    remove_index :stories, :user_id
    remove_index :stories, :created_at
    remove_index :story_views, :created_at
    remove_index :story_views, [:story_id, :user_id]
    remove_index :taggings, [:taggable_id, :taggable_type] 
    remove_index :taggings, :tag_id
  end
end
