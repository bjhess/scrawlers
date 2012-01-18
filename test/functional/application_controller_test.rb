require File.dirname(__FILE__) + '/../test_helper'
require 'application'

# Raise errors beyond the default web-based presentation
class ApplicationController
  def rescue_action(e) raise e end;
end

class ApplicationControllerTest < Test::Unit::TestCase

  def setup
    @controller = ApplicationController.new
    @request, @response = ActionController::TestRequest.new, ActionController::TestResponse.new
  end
  
  def test_truth
    assert true
  end

end
