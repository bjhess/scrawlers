# Be sure to restart your web server when you modify this file.

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.2.2' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  config.load_paths += %W( #{RAILS_ROOT}/app/sweepers )

  config.gem 'haml'
  config.gem 'twitter4r', :lib => 'twitter'
  if RAILS_ENV == 'development'
    # config.gem 'fiveruns_tuneup'
  end
  # Settings in config/environments/* take precedence those specified here

  # Skip frameworks you're not going to use (only works if using vendor/rails)
  # config.frameworks -= [ :action_web_service, :action_mailer ]

  # Add additional load paths for your own custom dirs
  # config.load_paths += %W( #{RAILS_ROOT}/extras )

  # Force all environments to use the same logger level
  # (by default production uses :info, the others :debug)
  # config.log_level = :debug

  # Use the database for sessions instead of the file system
  # (create the session table with 'rake db:sessions:create')
  # config.action_controller.session_store = :active_record_store
  config.action_controller.session = { :key => "_myapp_session", :secret => "waepoijasdfjksad9u8asd98uafjos98uasdfu890asdpju890fa9p8jadsf" }

  # Use SQL instead of Active Record's schema dumper when creating the test database.
  # This is necessary if your schema can't be completely dumped by the schema dumper,
  # like if you have constraints or database-specific column types
  # config.active_record.schema_format = :sql
  config.active_record.colorize_logging = RAILS_ENV == 'development'

  # Activate observers that should always be running
  config.active_record.observers = :user_observer

  # Make Active Record use UTC-base instead of local time
  # config.active_record.default_timezone = :utc

  # See Rails::Configuration for more options

end

# Include your application configuration below

PAGE_SIZE = 10

require 'twitter'
require 'twitter/console'
require 'twitter/rails'

module TweetApp
  ENV["RAILS_ENV"] ||= "test" # assume test environment if no RAILS_ENV set.
  ClientContext = Twitter::Client.from_config("#{RAILS_ROOT}/config/twitter.yml", ENV["RAILS_ENV"])
end

class Logger
  def format_message(severity, timestamp, progname, msg)
    "#{severity} #{timestamp} (#{$$})\n #{msg}\n"
  end
end

ExceptionNotifier.sender_address = %(support@scrawlers.com)
ExceptionNotifier.exception_recipients = %w(barry.hess@scrawlers.com)

scrawlers_time_formats = {
  :chatty => "%A, %B %d, %Y at %I:%M%p Central Time",
  :hour   => "%I"
}
scrawlers_date_formats = {
  :clean => "%d %b %Y",        # 21 Feb 2008
  :normal => "%b %d %Y",       # Feb 21 2008
  :report => "%Y %b %d",       # 2008 Feb 21
  :recent => "%b %d - %A",     # Feb 21 - Thursday
  :short_recent => "%b %d",    # Feb 21 - Thursday
  :datepicker => "%m/%d/%Y",   # 02/21/2008
  :widget => "%a, %d %b %Y",   # Thu, 21 Feb 2008
  :month_day => "%B %d",       # March 21
  :year_day => "%Y%j"          # 2008038
}
ActiveSupport::CoreExtensions::Date::Conversions::DATE_FORMATS.update(scrawlers_date_formats)
ActiveSupport::CoreExtensions::Time::Conversions::DATE_FORMATS.update(scrawlers_date_formats)
ActiveSupport::CoreExtensions::Time::Conversions::DATE_FORMATS.update(scrawlers_time_formats)

def yell(msg) 
  # stupid simple logging:
  f = File.open(File.expand_path(File.dirname(__FILE__) + "/../log/yell.log"),"a") 
  f.puts msg 
  f.close
end