class HomeController < ApplicationController
  
  skip_before_filter :redirect_all, :only => :index
  
  layout "homepage"
  
  def index
    render :action => :logged_in_index, :layout => "single_column" if logged_in?
  end

  def index_registered
    redirect_to :action => :index
  end
end
