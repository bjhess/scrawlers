class AdminController < ApplicationController
  #TODO Display FAQ bits in scaffolding
  scaffold_all_models :except => [Question]
  before_filter :login_required, :user_check
  
  def user_check
    valid_users = %w{ barry@bjhess.com barry.hess@scrawlers.com nate.melcher@gmail.com nathan.melcher@scrawlers.com }
    valid_users.include?(current_user.email) ? 
                true : 
                access_denied #access_denied redirects to login screen
  end
  
  def overview
    @user_count = User.count
    @story_count = Story.count
    @comment_count = Comment.notes.size
    @response_count = Comment.responses.size
    unique_author_count = Story.count_by_sql("SELECT COUNT(distinct user_id) FROM stories")
    @authorship_percentage = unique_author_count.to_f / @user_count.to_f
    unique_commentor_count = Comment.count_by_sql("SELECT COUNT(distinct user_id) FROM comments")
    @commentor_percentage = unique_commentor_count.to_f / @user_count.to_f
  end
end
