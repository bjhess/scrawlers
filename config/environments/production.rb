# Settings specified here will take precedence over those in config/environment.rb

# The production environment is meant for finished, "live" apps.
# Code is not reloaded between requests
config.cache_classes = true

# Use a different logger for distributed setups
# config.logger = SyslogLogger.new

# Full error reports are disabled and caching is turned on
config.action_controller.consider_all_requests_local = false
config.action_controller.perform_caching             = true

# Enable serving of images, stylesheets, and javascripts from an asset server
# config.action_controller.asset_host                  = "http://assets.example.com"

# Disable delivery errors if you bad email addresses should just be ignored
# config.action_mailer.raise_delivery_errors = false
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
# ActionMailer::Base.perform_deliveries = true
# ActionMailer::Base.default_charset = 'utf-8'

#RAILS_DEFAULT_LOGGER.level = Logger::INFO

APP_DOMAIN = 'www.scrawlers.com'