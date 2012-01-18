class TheScrawlController < ApplicationController

  layout "single_column"
  
  def about_us
    @nate = User.find_by_email("nate.melcher@gmail.com")
    @barry = User.find_by_email("barry@bjhess.com")
  end
  
  def faq
    @faq_sections = FaqSection.find(:all,
                                    :conditions => ["parent_id is NULL"])
  end
  
end
