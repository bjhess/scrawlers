require File.dirname(__FILE__) + '/../test_helper'
require 'sessions_controller'

# Re-raise errors caught by the controller.
class SessionsController; def rescue_action(e) raise e end; end

class SessionsControllerTest < Test::Unit::TestCase

  fixtures :users

  def setup
    @controller = SessionsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    # for testing action mailer
    ActionMailer::Base.delivery_method = :test
    ActionMailer::Base.perform_deliveries = true
    ActionMailer::Base.deliveries = []

    @emails = ActionMailer::Base.deliveries
    @emails.clear
  end

  def test_should_login_and_redirect
    post :login, :email => 'quentin@example.com', :password => 'password'
    assert session[:user]
    assert_redirected_to :controller => 'home'
  end

  def test_should_fail_login_and_not_redirect
    post :login, :email => 'quentin@example.com', :password => 'bad password'
    assert_nil session[:user]
    assert_response :success
  end

  def test_should_allow_signup
    assert_difference User, :count do
      create_user
      assert_response :redirect
    end
  end
  
  def test_should_signup_user
    post :signup, :user => user_options
    assert_redirected_to :action => 'welcome'

    # Test emailing
    assert_equal 1, @emails.length
    assert(@emails.first.subject =~ /Please activate your new account/)
    assert(@emails.first.body    =~ /Your account has been created/)
    assert(@emails.first.body    =~ /Email: #{assigns(:user).email}/)
    assert(@emails.first.body    =~ /sessions\/activate\/#{assigns(:user).activation_code}/)
  end
  
  def test_should_activate_user
    users(:quentin).update_attributes(:activation_code => '1234')
    get :activate, :id => users(:quentin).activation_code
    assert_equal users(:quentin), User.authenticate('quentin@example.com', 'password')
    assert_response :redirect
    assert_redirected_to home_path
    assert assigns(:user)
    assert_equal "Your account has been activated.", flash[:notice]
    
    # Test emailing
    assert_equal 1, @emails.length
    expected_subject = "Your account has been activated"
    assert(@emails.first.subject =~ /#{expected_subject}/,
           "Something like the following expected: #{expected_subject}}\n" +
           "Received: #{@emails.first.subject}")
    expected_body = "Your account (#{assigns(:user).email}) has been activated"
    assert(@emails.first.body    =~ /has been activated/, 
           "Something like the following expected: #{expected_body}\n" +
           "Received: #{@emails.first.body}")
  end

  def test_should_fail_to_activate_user
    get :activate, :id => users(:quentin).activation_code  # nil
    assert_response :redirect
    assert_redirected_to :controller => :home
    assert_equal "It looks like you're trying to activate an account.  Perhaps you have already activated this account?", flash[:notice]
    
    # Make sure no email was sent             
    assert_equal 0, @emails.length
  end
  
  def test_should_require_login_on_signup
    assert_no_difference User, :count do
      create_user(:email => nil)
      assert assigns(:user).errors.on(:email)
      assert_response :success
    end
  end

  def test_should_require_password_on_signup
    assert_no_difference User, :count do
      create_user(:password => nil)
      assert assigns(:user).errors.on(:password)
      assert_response :success
    end
  end

  def test_should_require_password_confirmation_on_signup
    assert_no_difference User, :count do
      create_user(:password_confirmation => nil)
      assert assigns(:user).errors.on(:password_confirmation)
      assert_response :success
    end
  end

  def test_should_require_email_on_signup
    assert_no_difference User, :count do
      create_user(:email => nil)
      assert assigns(:user).errors.on(:email)
      assert_response :success
    end
  end

  def test_should_logout
    login_as :quentin
    get :logout
    assert_nil session[:user]
    assert_response :redirect
  end

  def test_should_remember_me
    post :login, :email => 'quentin@example.com', :password => 'password', :remember_me => "1"
    assert_not_nil @response.cookies["auth_token"]
  end

  def test_should_not_remember_me
    post :login, :email => 'quentin@example.com', :password => 'password', :remember_me => "0"
    assert_nil @response.cookies["auth_token"]
  end
  
  def test_should_delete_token_on_logout
    login_as :quentin
    get :logout
    assert_equal @response.cookies["auth_token"], []
  end

  protected
    def create_user(options = {})
      post :signup, :user => user_options.merge(options)
    end
    
    def user_options
      { :email => 'manuel@fawlty.com',
        :display_name => 'Manuel',
        :password => 'quepassword', 
        :password_confirmation => 'quepassword' }
    end
    
    def auth_token(token)
      CGI::Cookie.new('name' => 'auth_token', 'value' => token)
    end
    
    def cookie_for(user)
      auth_token users(user).remember_token
    end
end
