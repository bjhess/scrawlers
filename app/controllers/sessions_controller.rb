class SessionsController < ApplicationController
  layout "minimal"
  
  filter_parameter_logging :password, :password_confirmation

  # If you want "remember me" functionality, add this before_filter to Application Controller
  before_filter :login_from_cookie
  
  def login
    return unless request.post?
    self.current_user = User.authenticate(params[:email], params[:password])
    if logged_in?
      if params[:remember_me] == "1"
        self.current_user.remember_me
        cookies[:auth_token] = { :value => self.current_user.remember_token , :expires => self.current_user.remember_token_expires_at }
      end
      redirect_back_or_default(home_path)
    else
      flash.now[:error] = "Incorrect email and password combination"
    end
  end

  def signup
    @title = "Join Scrawlers"
    @user = User.new(params[:user])
    return unless request.post?
    @user.save!
    # self.current_user = @user
    #TODO Move expirations into fragments
    expire_fragment("home/index")
    expire_fragment("home/logged_in_index")
    redirect_back_or_default(:controller => :sessions, :action => :welcome)
  rescue ActiveRecord::RecordInvalid
    render :action => 'signup'
  end
  
  def welcome
    render :layout => "single_column"
  end
  
  def logout
    self.current_user.forget_me if logged_in?
    cookies.delete :auth_token
    reset_session
    redirect_back_or_default(:controller => :home)
  end

  def activate
    @user = User.find_by_activation_code(params[:id]) if params[:id]
    if @user and @user.activate
      self.current_user = @user
      redirect_back_or_default(home_path)
      flash[:notice] = "Your account has been activated." 
    else
      redirect_back_or_default(:controller => :home)
      flash[:notice] = "It looks like you're trying to activate an account.  Perhaps you have already activated this account?"
    end
  end
    
end
