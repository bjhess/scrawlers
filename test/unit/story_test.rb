require File.dirname(__FILE__) + '/../test_helper'

class StoryTest < Test::Unit::TestCase
  fixtures :stories, :users, :comments, :tags, :taggings

  should_belong_to :user
  should_have_many :notes
  should_have_many :responses
  should_have_many :story_commentators
  should_have_many :invitations
  should_have_many :favoriteds
  should_have_many :fans, :through => :favoriteds
  
  should_require_attributes :title, :body, :user_id
  should_ensure_length_in_range :title, 1..40

  def setup
    @santana = User.create(:email => 'johan@twins.com',
                           :display_name => 'Johan',
                           :password => 'cyyoung',
                           :password_confirmation => 'cyyoung')
    @santana.activate
    @morneau = User.create(:email => 'justin@twins.com',
                           :display_name => 'Justin',
                           :password => 'mvp2006',
                           :password_confirmation => 'mvp2006')
    @morneau.activate
    @mauer = User.create(:email => 'joe@twins.com',
                         :display_name => 'Joe',
                         :password => 'champ2006',
                         :password_confirmation => 'champ2006')
    @mauer.activate
    
    @santana_story = Story.create(:title => "Johan's Story",
                                  :body => "Johan really wrote a good story, right?")
    @santana_story.user = @santana
    @santana_story.save
    
    @santana_story2 = Story.create(:title => "Johan's Story",
                                  :body => "Johan really wrote a good story, right?")
    @santana_story2.user = @santana
    @santana_story2.save
    
    @morneau_story = Story.create(:title => "Justin's Story",
                                  :body => "Justing really wrote a good story, right?")
    @morneau_story.user = @morneau
    @morneau_story.save
    
    @morneau_story2 = Story.create(:title => "Justin's Story",
                                  :body => "Justing really wrote a good story, right?")
    @morneau_story2.user = @morneau
    @morneau_story2.save

    @morneau_comment = Comment.create(:body => 'Morneau comments on a Johan story.',
                                      :story_id => @santana_story,
                                      :user_id => @morneau)        
    @morneau_comment.user = @morneau
    @morneau_comment.story = @santana_story
    @morneau_comment.save
  end

  def test_invalid_with_empty_attributes
    assert_no_difference Story, :count do
      s = Story.create
      assert !s.valid?
      assert s.errors.invalid?(:title)
      assert s.errors.invalid?(:body)
      assert s.errors.invalid?(:user_id)
    end
  end
  
  def test_title_length_upper_limit
    assert_no_difference Story, :count do
      s = create_story(:title => "12345678901234567890123456789012345678901")
      assert s.errors.on(:title)
    end
    assert_difference Story, :count do
      s = create_story(:title => "1234567890123456789012345678901234567890", :user_id => 2)
      assert !s.new_record?, "#{s.errors.full_messages.to_sentence}"
    end    
  end
  
  def test_should_allow_99_word_story
    assert_difference(Story, :count) do
      s = create_story(:body => "word " * 99)
      assert_equal true, s.valid?
    end
  end
  
  def test_should_allow_100_word_story
    assert_difference(Story, :count) do
      s = create_story(:body => "word " * 100)
      assert_equal true, s.valid?
    end
  end
  
  def test_should_allow_100_word_dashed_words
    assert_difference(Story, :count) do
      s = create_story(:body => "one-word " * 100)
      assert_equal true, s.valid?
    end
  end
  
  def test_should_not_all_101_word_story
    assert_no_difference(Story, :count) do
      s = create_story(:body => "word " * 101)
      assert_equal false, s.valid?
    end    
  end
  
  def test_find_recent
    find_recent_tests(9)
    find_recent_tests(9, 100)
    find_recent_tests(2, 2)
  end
  
  def test_find_recent_excluding_user
    find_recent_excluding_user_tests(users(:quentin).id, 
                                     stories(:ten_days_ago_story).published_at, 
                                     7)
    find_recent_excluding_user_tests(users(:quentin).id, 
                                     stories(:ten_days_ago_story).published_at, 
                                     1, 
                                     1)
    find_recent_excluding_user_tests(users(:aaron).id, 
                                     stories(:yesterdays_story).published_at, 
                                     6)
  end
  
  def find_recent_tests(expected_story_list_count, number_of_stories=50)
    story_list = Story.find_recent(number_of_stories)
    assert_equal expected_story_list_count, story_list.length
    #ordering correct
    assert_descending_order(story_list)
  end
  
  
  def find_recent_excluding_user_tests(user_id, newest_story_date, expected_story_list_count, number_of_stories=50)
    story_list = Story.find_recent_excluding_user(user_id, number_of_stories)
    assert_equal expected_story_list_count, story_list.length
    #ordering correct
    assert_descending_order(story_list)
    story_list.each do |s|
      assert_not_equal user_id, s.user_id
    end
  end
  
  def test_delete_tag
    assert_equal 1, stories(:yesterdays_story).tags.length
    assert_equal tags(:fiction).name, stories(:yesterdays_story).tags[0].name
    st = stories(:yesterdays_story)
    st.delete_tag(tags(:fiction).name)
    st = Story.find_by_id(stories(:yesterdays_story).id)
    assert_equal 0, st.tags.length
  end
  
  def test_should_allow_editing_because_there_are_no_comments
    assert @morneau_story.allow_editing?(@morneau)
  end
  
  def test_should_not_allow_editing_because_there_are_comments
    assert !@santana_story.allow_editing?(@santana)
  end
  
  def test_should_not_allow_editing_by_different_user
    assert !@morneau_story.allow_editing?(@santana)
  end
  
  def test_should_get_one_story_by_user_id
    stories = Story.find_all_by_user_id_sorted(@santana.id, 1)
    assert_equal 1, stories.size
    assert_equal Story.find(:all, :order => "updated_at DESC, published_at DESC").first.body, stories.first.body
  end
  
  def test_should_get_all_stories_by_user_id
    stories = Story.find_all_by_user_id_sorted(@santana.id, 1)
    
    # Technically this call is probably not adequate because it doesn't check updated_at sorting
    assert_descending_order(stories)
  end
  
  def test_should_find_most_recent_time_by_user_id
    story_time = Story.find_most_recent_time_by_user_id(@santana.id)
    assert_equal @santana_story2.updated_at.to_s, story_time.to_s
  end
  
  def test_should_not_find_any_recent_times_by_user_id
    story_time = Story.find_most_recent_time_by_user_id(@mauer.id)
    assert_equal Date.new(2007, 1, 1).to_time, story_time    
  end
  
  protected
    def create_story(options = {})
      s=Story.new({ :title => 'A Noble Man',
                       :body => "I want to be just like Uncle Steve when I grow up. Boy, does he live the life. Every evening starts with dinner, and then it's off to the races. Sports Center is on first. That gets him level and ready for a night of great accomplishment.",  
                       :published_at => Time.now }.merge(options))
      s.user_id = options[:user_id] || users(:quentin).id
      s.save
      s
    end
end
