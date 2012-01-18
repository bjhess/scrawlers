##
# Serves as a super class to StoryFavoritedsController and UserFavoritedsController
class FavoritedsController < ApplicationController
  before_filter :load_parent
  before_filter :load_favorited
  
  protected
  
    def load_parent
      # Overridden in subclasses
    end
    
    def load_favorited
      @favoriteds = @parent.favoriteds
    end
    
end
