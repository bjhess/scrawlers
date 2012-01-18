default_run_options[:pty] = true  # Force password prompt from git

set :user, "bjhess"
set :domain, "scrawlers.com"
set :application, "scrawlers.com"

set :repository, "git@github.com:bjhess/scrawlers.git"
set :deploy_to, "/home/#{user}/scrawlers.com"
set :deploy_via, :remote_cache
set :scm, 'git'
set :scm_passphrase, '1steve9'
set :branch, 'origin/master'
set :git_shallow_clone, 1
set :scm_verbose, true
set :use_sudo, false
set :keep_releases, '10'

server domain, :app, :web
role :db,  domain, :primary => true

# =============================================================================
# Custom tasks
# =============================================================================

namespace :deploy do
  
  desc "Tasks to complete after code update"
  task :after_update_code do
    run "ln -nfs #{deploy_to}/#{shared_dir}/config/database.yml #{current_release}/config/database.yml"
    compile_sass_files_and_pack_assets
  end

  namespace :web do
    desc "Disable_web to use a real RHTML file! (OVERRIDE)"
    task :disable, :roles => :web, :except => { :no_release => true } do
      require 'erb'
      on_rollback { run "rm #{shared_path}/system/maintenance.html" }

      reason = ENV['REASON']
      deadline = ENV['UNTIL']

      template = File.read("./app/views/layouts/maintenance.rhtml")
      result = ERB.new(template).result(binding)

      put result, "#{shared_path}/system/maintenance.html", :mode => 0644
    end
  end
  
  desc "Restart Application"
  task :restart do
    run "touch #{current_path}/tmp/restart.txt"
  end
end

task :compile_sass_files_and_pack_assets, :roles => [:app, :web] do
  run "cd #{release_path} && RAILS_ENV=production script/runner 'Sass::Plugin.update_stylesheets'"
end

desc 'Gather email addresses for all activated users'
task :get_email_list, :roles => :app do
  run "RAILS_ENV=production #{current_path}/script/runner '" +
        "puts \"Email list: \" + User.find(:all).select{|u| u.activation_code.blank?}.map(&:email).join(\", \")" +
      "'"
end

task :get_stale_email_list, :roles => :app do
  run 'rake scrawl:stale_email_list'
end

# TODO Find something better without requiring a password.  Maybe a rake task that uses the DB config to load password.
#      Then call from here
# TODO Clean up all but last n DB backups
desc 'Backup production database to /home/bjhess/scrawlers.com/shared/backups/backupTIMESTAMP.sql file.'
task :backup, :roles => :db, :only => { :primary => true } do
  # on_rollback { delete "/home/bjhess/scrawlers.com/shared/backups/backup#{releases.last}.sql" }
  run "mysqldump --single-transaction --disable-keys --extended-insert --quick --quote-names -h mysql.bjhess.com -u scrawlp -p4lav0R scrawlers_production > /home/bjhess/scrawlers.com/shared/backups/backup#{releases.last}.sql"
end
before("deploy:migrate", :backup)

after "deploy", "deploy:cleanup"
after "deploy:migrations", "deploy:cleanup"