require File.dirname(__FILE__) + '/../test_helper'

class ContestTest < ActiveSupport::TestCase
  fixtures :contests
  
  should_belong_to :first_place_story

  def setup
    @now = Time.now
  end

  def test_should_find_active_contest
    Contest.delete_all
    contest = create_contest(:end_time => @now.tomorrow)
    assert_equal contest, Contest.find_active_contest
  end
  
  def test_should_not_find_active_contest
    Contest.delete_all
    contest = create_contest(:end_time => @now.yesterday)
    assert_equal nil, Contest.find_active_contest
  end
  
  def test_should_find_all_contests_in_the_past
    Contest.delete_all
    create_contest(:start_time => @now.months_ago(2), :end_time => @now.months_ago(1))
    create_contest(:end_time => @now.yesterday)
    assert_equal 2, Contest.find_all_past_contests.size
  end
  
  def test_should_not_find_any_contests_in_the_past
    Contest.delete_all
    create_contest(:end_time => @now.tomorrow)
    create_contest(:start_time => @now.months_since(1), :end_time => @now.months_since(0))
    assert_equal 0, Contest.find_all_past_contests.size
  end
  
  private
  
    def create_contest(options={})
      Contest.create(
      {
        :title       => "A contest",
        :tag_name    => "resistance", 
        :prize_link  => "http://bjhess.com", 
        :image_link  => "http://bjhess.com/image.jpg",
        :description => "Contest description", 
        :start_time  => @now.last_month,
        :end_time    => @now.yesterday,  
        :prize_title => "Barry Hess subscription"
      }.merge(options))
    end
end
