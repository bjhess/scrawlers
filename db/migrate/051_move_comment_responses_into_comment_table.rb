class MoveCommentResponsesIntoCommentTable < ActiveRecord::Migration
  def self.up
    add_column :comments, :parent_id, :integer

    for story in Story.find(:all)
      for comment in story.comments
        if comment.comment_response
          c = Comment.new(:body => comment.comment_response.body)
          c.story_id = comment.story_id
          c.user_id= story.user_id
          c.parent_id = comment.id
          c.created_at = comment.comment_response.created_at
          c.save
        end
      end
    end
    
    drop_table :comment_responses
  end

  def self.down
    create_table :comment_responses do |t|
      t.column :comment_id, :integer
      t.column :body, :text
      t.column :created_at, :datetime
    end
    
    for comment in Comment.find(:all)
      if comment.parent_id
        cr = CommentResponse.new(:body => comment.body)
        cr.comment_id = comment.parent_id
        cr.created_at = comment.created_at
        cr.save
        comment.destroy
      end
    end
    
    remove_column :comments, :parent_id
  end
end
