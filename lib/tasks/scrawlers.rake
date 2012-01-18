namespace :test do

  desc 'Measures test coverage'
  task :coverage do
    rm_f "coverage"
    rm_f "coverage.data"
    rcov = "rcov --rails --aggregate coverage.data --text-summary -Ilib"
    system("#{rcov} --no-html test/unit/*_test.rb")
    system("#{rcov} --no-html test/functional/*_test.rb")
    system("#{rcov} --html test/integration/*_test.rb")
    system("open coverage/index.html") if PLATFORM['darwin']
  end

end

namespace :scrawl do

  desc 'Gather email address for all users registered over one month ago who have not written, commented or voted in the past month.'
  task :stale_email_list => :environment do
    last_month      =  Time.now.last_month
    recent_user_ids =  Story.find(:all, :conditions => ["created_at > ?", last_month]).map(&:user_id)
    recent_user_ids << Comment.find(:all, :conditions => ["created_at > ?", last_month]).map(&:user_id)
    recent_user_ids << Rating.find(:all, :conditions => ["created_at > ?", last_month]).map(&:user_id)
    
    puts User.find(:all, :conditions => ["created_at < ? AND id NOT IN (#{recent_user_ids.flatten.uniq.join(',')})", last_month]).select{|u| u.activation_code.blank?}.map(&:email).join(', ')
  end
  
  desc 'Supply contest_id to generate a random winner'
  task :contest_winner => :environment do
    raise "usage: rake scrawl:contest_winner contest_id=2" if !ENV.include?("contest_id")

    contest_id = ENV['contest_id'].to_i
    contest = Contest.find(contest_id)
    raise "Contest with id [#{contest_id}] not found" if !contest

    entry_user_ids = contest.entry_user_ids
    puts "Winning entry: #{entry_user_ids[rand(entry_user_ids.size)]}"
  end
end