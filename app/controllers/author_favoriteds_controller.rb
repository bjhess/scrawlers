class AuthorFavoritedsController < FavoritedsController

  helper :users

  before_filter :login_required

  def create
    @author.favoriteds.create(:user => current_user)
    respond_to do |wants|
      wants.js
    end
  end

  def destroy
    favorite = @author.favoriteds.find(params[:id])
    favorite.destroy
    respond_to do |wants|
      wants.js
    end
  end

  protected
  
    def load_parent
      @parent = @author = User.find(params[:user_id])
    end

end
