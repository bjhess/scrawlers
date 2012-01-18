require File.dirname(__FILE__) + '/../test_helper'
require 'user_notifier'

class UserNotifierTest < Test::Unit::TestCase
  FIXTURES_PATH = File.dirname(__FILE__) + '/../fixtures'
  CHARSET = "utf-8"

  include ActionMailer::Quoting

  fixtures :users
  
  def setup
    ActionMailer::Base.delivery_method = :test
    ActionMailer::Base.perform_deliveries = true
    ActionMailer::Base.deliveries = []

    @expected = TMail::Mail.new
    @expected.set_content_type "text", "plain", { "charset" => CHARSET }
  end
  
  # Replace this with your real tests.
  def test_truth
    assert true
  end
  
  #def test_reset_password
  #  UserNotifier.reset_password(users(:quentin))
  #  setup_email_test
  #end

  private
    def setup_email_test
      assert_equal users(:quentin).email, @recipients
      assert_equal "support@scrawlers.com", @from
      assert @sent_on > 2.seconds.ago
      assert_equal users(:quentin), @body[:user]
    end
    
    def read_fixture(action)
      IO.readlines("#{FIXTURES_PATH}/user_notifier/#{action}")
    end

    def encode(subject)
      quoted_printable(subject, CHARSET)
    end
end
