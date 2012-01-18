class UsersController < ApplicationController

  layout "single_column"
  before_filter :login_required, :except => [:index, :show, :forgot_password, :reset_password]
  
  # TODO: More efficiently compile these stats
  def index; end
  
  def show
    @user = User.find(params[:id])
    redirect_to recent_stories_path and return if !@user
    recent_stories_and_comments(@user)
    @latest_favorite_stories = @user.favorite_stories.latest(5)
    @favorite_authors        = @user.favorite_authors
    @fans                    = @user.fans
    render :layout => "two_column"
  end
  
  def edit
    logged_in? ? @user = current_user : redirect_to(:controller => :sessions, :action => :signup)
  end

  # TODO: RESTfulize this method
  def update_profile
    @user = current_user
    if request.post?
      @user.update_attributes!(params[:user])
      flash[:notice] = "Your profile has been updated"
      redirect_back_or_default(edit_user_path(@user))
    end
  rescue ActiveRecord::RecordInvalid
    render :action => 'update_profile'
  end
  
  # TODO: RESTfulize this method
  def update_email
    @user = current_user
    return unless request.post?
    if !params[:user][:email].blank?
      @user.change_email_address(params[:user][:email])
      if @user.save
        @changed = true
      end
    else
      flash[:notice] = "Please enter an email address"
    end
  end

  # TODO: RESTfulize this method
  def activate_new_email
    flash.clear
    return if params[:id] == nil && params[:email_activation_code] == nil

    activator = params[:id] || params[:email_activation_code]
    @user = User.find_by_email_activation_code(activator)
    if @user && @user.activate_new_email
      notice = "The email address for your account has been updated"
      if @user.is_same_user?(current_user)
        redirect_back_or_default(edit_user_path(@user))
      else
        redirect_back_or_default(:controller => :sessions, :action => :logout, :notice => notice )
      end
      flash[:notice] = notice
    else
      flash[:notice] = "Unable to update the email address"
    end
  end
  
  # TODO: RESTfulize this method
  def update_password
    @user = current_user
    return unless request.post?
    if User.authenticate(current_user.email, params[:old_password])
      if (params[:password] == params[:password_confirmation])
        current_user.password_confirmation = params[:password_confirmation]
        current_user.password = params[:password]
        if !params[:password].blank? && current_user.save
          flash[:notice] = "Password changed" 
          redirect_to edit_user_path(current_user)
        else
          flash[:notice] = "Password not changed"
        end
      else
        flash[:notice] = "Password mismatch"
        @old_password = params[:old_password]
      end
    else
      flash[:notice] = "Wrong password" 
    end  
  end

  # TODO: RESTfulize this method
  def forgot_password
    render :layout => 'minimal' and return if request.get?

    if @user = User.find_by_email(params[:email])
      @user.forgot_password
      @user.save
      flash[:notice] = "A password reset link has been sent to #{@user.email}" 
      redirect_to :controller => :sessions, :action => :login
    else
      flash.now[:error] = "Could not find a user with that email address" 
      render :layout => 'minimal'
    end
  end

  # TODO: RESTfulize this method
  def reset_password
    @user = User.find_by_password_reset_code(params[:id]) if params[:id]
    render :layout => 'minimal' and return if @user && request.get?
    flash.clear
    if (params[:password] == params[:password_confirmation])
      self.current_user = @user #for the next two lines to work
      current_user.password_confirmation = params[:password_confirmation]
      current_user.password = params[:password]
      @user.reset_password
      if current_user.save
        flash[:notice] = "Password reset"
        redirect_back_or_default(user_path(@user))
      end
    else
      flash[:notice] = "Password mismatch" 
      render :layout => 'minimal'
    end  
    rescue
      logger.error "Invalid Reset Code entered for: " + (@user ? @user.email : "none found") 
      flash[:notice] = "Sorry - That is an invalid password reset code. Please check your code and try again. (Perhaps your email client inserted a carriage return?)" 
      redirect_back_or_default(user_path(@user))
  end

  private

    def recent_stories_and_comments(user)
     @stories  = user.stories.recent(10)
     @comments = user.notes.recent(10)
    end
end
