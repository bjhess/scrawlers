##
# This is really only used as a nested route for a user
class FavoriteStoriesController < ApplicationController
  
  layout "single_column"
  helper :stories
  
  def index
    @user     = User.find(params[:user_id])
    @stories  = @user.favorite_stories.paged(params[:page])
    
    # Cross rendering over controllers is messy.  Redo story technique to make more global.
    render :template => 'stories/index'
  end
  
end
