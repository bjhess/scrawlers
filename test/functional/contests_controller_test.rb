require File.dirname(__FILE__) + '/../test_helper'

class ContestsControllerTest < ActionController::TestCase
  fixtures :contests

  def test_should_get_index
    get :index
    assert_response :success
    assert_assigns :header
  end

  def test_should_show_contest
    get :show, :id => contests(:past).id
    assert_response :success
    assert_assigns :header, :contest
  end
end
