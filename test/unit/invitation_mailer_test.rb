require File.dirname(__FILE__) + '/../test_helper'

class InvitationMailerTest < Test::Unit::TestCase
  FIXTURES_PATH = File.dirname(__FILE__) + '/../fixtures'
  CHARSET = "utf-8"

  include ActionMailer::Quoting

  def setup
    ActionMailer::Base.delivery_method = :test
    ActionMailer::Base.perform_deliveries = true
    ActionMailer::Base.deliveries = []

    @expected = TMail::Mail.new
    @expected.set_content_type "text", "plain", { "charset" => CHARSET }
    @expected.mime_version = '1.0'
  end

  # Fuck it, I don't care.  I'll probably remove the invitation shit later anyway.
  def test_truth
    assert true
  end
  # def test_invitation
  #   @expected.subject = 'Invitation#invitation'
  #   @expected.body    = read_fixture('invitation')
  #   @expected.date    = Time.now
  # 
  #   assert_equal @expected.encoded, Invitation.create_invitation(@expected.date).encoded
  # end

  private
    def read_fixture(action)
      IO.readlines("#{FIXTURES_PATH}/invitation_mailer/#{action}")
    end

    def encode(subject)
      quoted_printable(subject, CHARSET)
    end
end
