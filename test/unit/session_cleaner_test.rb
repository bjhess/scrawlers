require File.dirname(__FILE__) + '/../test_helper'

class SessionCleanerTest < Test::Unit::TestCase
  fixtures :sessions

  def test_cleanup
    assert_equal 2, Session.count
    assert_not_nil Session.find_by_id(1)
    SessionCleaner.remove_stale_sessions
    assert_equal 1, Session.count
    assert_nil Session.find_by_id(1)
    assert_not_nil Session.find_by_id(2)
  end

end
