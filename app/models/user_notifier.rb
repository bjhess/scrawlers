class UserNotifier < ActionMailer::Base
  
  def signup_notification(user)
    setup_email(user)
    @subject    += ' - Please activate your new account'
    @body[:url]  = "http://#{APP_DOMAIN}/sessions/activate/#{user.activation_code}"
  end
  
  def activation(user)
    setup_email(user)
    @subject    += ' - Your account has been activated!'
    @body[:url]  = "http://#{APP_DOMAIN}/"
  end
  
  def change_email(user)
    setup_email(user)
    @recipients  = "#{user.new_email}" 
    @subject    += ' - Request to change your email'
    @body[:url]  = "http://#{APP_DOMAIN}" + activate_new_email_path(:id => user.email_activation_code)
  end
  
  def forgot_password(user)
    setup_email(user)
    @subject    += ' - Request to change your password'
    @body[:url]  = "http://#{APP_DOMAIN}" + reset_password_path(:id => user.password_reset_code)
  end
  
  def reset_password(user)
    setup_email(user)
    @subject += ' - Your password has been reset'
  end
  
  protected
    def setup_email(user)
      @recipients  = "#{user.email}"
      @from        = "support@scrawlers.com"
      @subject     = "Scrawlers.com"
      @sent_on     = Time.now
      @body[:user] = user
  end
end
