class InvitationMailer < ActionMailer::Base
  include ActionController::UrlWriter
  default_url_options[:host] = 'www.scrawlers.com'

  def invitation(email, invitation, sent_at = Time.now)
    @subject = "#{invitation.user.display_name} has invited you to read a story at Scrawlers"
    @body[:invitation] = invitation
    #@body[:url] = url
    #@body[:story] = story
    #@body[:user] = user
    @recipients = email
    @from = "support@scrawlers.com"
    @sent_on = sent_at
  end
end
