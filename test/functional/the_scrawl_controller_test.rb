require File.dirname(__FILE__) + '/../test_helper'
require 'the_scrawl_controller'

# Re-raise errors caught by the controller.
class TheScrawlController; def rescue_action(e) raise e end; end

class TheScrawlControllerTest < Test::Unit::TestCase
  def setup
    @controller = TheScrawlController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
