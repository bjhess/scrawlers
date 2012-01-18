require File.dirname(__FILE__) + '/../test_helper'
require 'feed_controller'

# Re-raise errors caught by the controller.
class FeedController; def rescue_action(e) raise e end; end

class FeedControllerTest < Test::Unit::TestCase
  def setup
    @controller = FeedController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    
    # Create model objects as necessary
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

    @morneau_note = create_comment(:body => 'Morneau comments on a Johan story.',
                                   :story_id => @santana_story.id,
                                   :user_id => @morneau.id)
    @morneau_note2 = create_comment(:body => 'Morneau comments again on a Johan story.',
                                    :story_id => @santana_story.id,
                                    :user_id => @morneau.id)
    @morneau_note3 = create_comment(:body => 'Morneau comments again on a Johan story.',
                                    :story_id => @santana_story2.id,
                                    :user_id => @morneau.id)
    @santana_response = create_comment(:body => 'Thanks for the note, Big Country',
                                       :story_id => @santana_story.id,
                                       :user_id => @santana.id,
                                       :parent_id => @morneau_note.id)
    
    @santana_note = create_comment(:body => 'Johan comments on a Morneau story.',
                                  :story_id => @morneau_story.id,
                                  :user_id => @santana.id)
  end

  def test_should_retrieve_stories_by_author
    get :stories_by_author, :id => @santana.id
    assert_response :success
    assert_template 'stories_by_author'
    assert_equal 'application/rss+xml', @response.content_type
    assert_equal Story.find_most_recent_time_by_user_id(@santana.id).httpdate,
                 @response.headers['Last-Modified']
    assert_assigns :author, :stories, :latest_story_time
  end
  
  def test_should_not_retrieve_stories_by_author
    @request.env['HTTP_IF_MODIFIED_SINCE'] = Story.find_most_recent_time_by_user_id(@santana.id).httpdate
    get :stories_by_author, :id => @santana.id
    assert_response 304
  end
  
  def test_should_retrieve_stories_if_author_no_stories
    get :stories_by_author, :id => @mauer.id
    assert_response :success
    assert_template 'stories_by_author'
    assert_equal 'application/rss+xml', @response.content_type
    assert_equal Story.find_most_recent_time_by_user_id(@mauer.id).httpdate,
                 @response.headers['Last-Modified']
    assert_assigns :author, :stories, :latest_story_time
  end
  
  def test_should_retrieve_comments_by_story
    get :comments_by_story, :id => @santana_story.id
    assert_response :success
    assert_template 'comments_by_story'
    assert_equal 'application/rss+xml', @response.content_type
    assert_equal Comment.find_most_recent_time_by_story_id(@santana_story.id).httpdate,
                 @response.headers['Last-Modified']
    assert_assigns :comments, :story, :story_author, :latest_comment_time
  end
  
  def test_should_not_retrieve_comments_by_story
    @request.env['HTTP_IF_MODIFIED_SINCE'] = Comment.find_most_recent_time_by_story_id(@santana_story.id).httpdate
    get :comments_by_story, :id => @santana_story.id
    assert_response 304
  end
  
  def test_should_retrieve_comments_if_no_comments
    get :comments_by_story, :id => @morneau_story.id
    assert_response :success
    assert_template 'comments_by_story'
    assert_equal 'application/rss+xml', @response.content_type
    assert_equal Comment.find_most_recent_time_by_story_id(@morneau_story.id).httpdate,
                 @response.headers['Last-Modified']
    assert_assigns :comments, :story, :story_author, :latest_comment_time
  end
  
  def test_should_retrieve_notes_for_author
    get :notes_for_author, :id => @santana.id
    assert_response :success
    assert_template 'notes_for_author'
    assert_equal 'application/rss+xml', @response.content_type
    assert_equal @santana.most_recent_received_note_time.httpdate,
                 @response.headers['Last-Modified']
    assert_assigns :author, :latest_note_time, :comments
  end
  
  def test_should_not_retrieve_notes_for_author
    @request.env['HTTP_IF_MODIFIED_SINCE'] = @santana.most_recent_received_note_time.httpdate
    get :notes_for_author, :id => @santana.id
    assert_response 304    
  end

  def test_should_retrieve_notes_for_author_if_no_notes
    get :notes_for_author, :id => @morneau.id
    assert_response :success
    assert_template 'notes_for_author'
    assert_equal 'application/rss+xml', @response.content_type
    assert_equal @morneau.most_recent_received_note_time.httpdate,
                 @response.headers['Last-Modified']
    assert_assigns :author, :latest_note_time, :comments
  end
  
  def test_should_retrieve_responses_for_author
    get :responses_for_author, :id => @morneau.id
    assert_response :success
    assert_template 'responses_for_author'
    assert_equal 'application/rss+xml', @response.content_type
    assert_equal @morneau.most_recent_received_response_time.httpdate,
                 @response.headers['Last-Modified']
    assert_assigns :author, :latest_response_time, :comments
  end
  
  def test_should_not_retrieve_responses_for_author
    @request.env['HTTP_IF_MODIFIED_SINCE'] = @morneau.most_recent_received_response_time.httpdate
    get :responses_for_author, :id => @morneau.id
    assert_response 304    
  end

  def test_should_retrieve_responses_for_author_if_no_responses
    get :responses_for_author, :id => @santana.id
    assert_response :success
    assert_template 'responses_for_author'
    assert_equal 'application/rss+xml', @response.content_type
    assert_equal @santana.most_recent_received_response_time.httpdate,
                 @response.headers['Last-Modified']
    assert_assigns :author, :latest_response_time, :comments
  end
  
  private
    def create_comment(options = {})
      c = new_comment(options)
      c.save
      c
    end

    def new_comment(options = {})
      c = Comment.new({ :body => 'This is a really helpful comment' }.merge(options))
      c.story_id = options[:story_id] || 2
      c.user_id = options[:user_id] || 1
      c.created_at = options[:created_at] || Time.now
      c.parent_id = options[:parent_id] || nil
      c
    end
end
