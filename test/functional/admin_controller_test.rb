require File.dirname(__FILE__) + '/../test_helper'
require 'admin_controller'

# Re-raise errors caught by the controller.
class AdminController; def rescue_action(e) raise e end; end

class AdminControllerTest < Test::Unit::TestCase
  fixtures :users
  
  def setup
    @controller = AdminController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_admin_with_no_logged_in_user
    [users(:quentin), users(:aaron), users(:shirley)].each do |email|
      get :index
      assert_response :redirect
      assert_redirected_to :controller => "sessions", :action => "login"
    end
  end
end
