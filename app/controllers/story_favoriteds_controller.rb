class StoryFavoritedsController < FavoritedsController

  helper :stories

  before_filter :login_required
  
  def create
    @story.favoriteds.create(:user => current_user)
    respond_to do |wants|
      wants.js
    end
  end

  def destroy
    favorite = @story.favoriteds.find(params[:id])
    favorite.destroy
    respond_to do |wants|
      wants.js
    end
  end
  
  protected
  
    def load_parent
      @parent = @story = Story.find(params[:story_id])
    end
  
end
