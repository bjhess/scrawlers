class LinkToElmoreLeonardInFaq < ActiveRecord::Migration
  def self.up
    question = Question.find_by_title("What are some tips / rules for good writing?")
    question.update_attribute(:answer,
                                  "The validity of writing tips is subjective, of course, but consider questions like both in your own writing and what you&rsquo;re reading: What is the voice of the story? What are the stakes involved in this story? Is the story providing enough &ldquo;show&rdquo; over &ldquo;tell&rdquo;? What could be cut and the story would still make sense? What&rsquo;s not on the page that needs to be there? Who is the intended audience for this story? We&rsquo;re a fan of Elmore Leonard (<em>Get Shorty</em>, <em>The Hot Kid</em>), and his <a href='http://www.elmoreleonard.com/index.php?/weblog/more/elmore_leonards_ten_rules_of_writing/'><em>Ten Rules of Writing</em></a> reads like a list of no-brainers.")
  end

  def self.down
    question = Question.find_by_title("What are some tips / rules for good writing?")
    question.update_attribute(:answer,
                                  "The validity of writing tips is subjective, of course, but consider questions like both in your own writing and what you&rsquo;re reading: What is the voice of the story? What are the stakes involved in this story? Is the story providing enough &ldquo;show&rdquo; over &ldquo;tell&rdquo;? What could be cut and the story would still make sense? What&rsquo;s not on the page that needs to be there? Who is the intended audience for this story? We&rsquo;re a fan of Elmore Leonard (Get Shorty, The Hot Kid), and his Ten Rules of Writing reads like a list of no-brainers.")
  end
end