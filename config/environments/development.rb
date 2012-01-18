# Settings specified here will take precedence over those in config/environment.rb

# In the development environment your application's code is reloaded on
# every request.  This slows down response time but is perfect for development
# since you don't have to restart the webserver when you make code changes.
config.cache_classes = false

# Log error messages when you accidentally call methods on nil.
config.whiny_nils = true

# Show full error reports and disable caching
# Disable consider_all_requests_local and application.rb#local_request? = false to test 404's locally
config.action_controller.consider_all_requests_local = true
config.action_controller.perform_caching             = false
config.action_view.debug_rjs                         = true

# Don't care if the mailer can't send
config.action_mailer.raise_delivery_errors = false
config.action_mailer.delivery_method = :test
# ActionMailer::Base.delivery_method = :smtp
# ActionMailer::Base.smtp_settings = {
#   :enable_starttls_auto => true,
#   :address        => "smtp.gmail.com",
#   :port           => 587,
#   :domain         => "scrawlers.com",
#   :authentication => :plain,
#   :user_name      => "support@scrawlers.com",
#   :password       => "4lav0R"
# }
# ActionMailer::Base.raise_delivery_errors = true

# Code from: http://brian.pontarelli.com/2007/01/14/handling-rails-404-and-500-errors/
ActionController::Base.consider_all_requests_local = false

# config.action_mailer.delivery_method = :smtp
config.action_mailer.smtp_settings = {
  :address => "smtp.charter.net"
}

APP_DOMAIN = 'localhost:3000'
