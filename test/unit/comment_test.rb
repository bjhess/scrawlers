require File.dirname(__FILE__) + '/../test_helper'

class CommentTest < Test::Unit::TestCase

  def setup
    # Create models for testing
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
    @santana_response = create_comment(:body => 'Thanks for the note, Big Country',
                                       :story_id => @santana_story.id,
                                       :user_id => @santana.id,
                                       :parent_id => @morneau_note.id)
    
    @santana_note = create_comment(:body => 'Johan comments on a Morneau story.',
                                  :story_id => @morneau_story.id,
                                  :user_id => @santana.id)
  end
  
  def test_validations
    # Should use this for all validation tests in the future.
    @model = new_comment

    assert_valid :body, 'this is a comment', 'comment', 'this_is_a_comment'
    assert_invalid :body, "can't be blank", '', ' ', nil
  end
  
  def test_should_retrieve_all_notes_by_user
    notes = Comment.find_notes_by_user_id(@morneau.id)
    test_notes = Comment.find(:all,
                              :conditions => "user_id = #{@morneau.id} AND parent_id IS NULL",
                              :order => 'created_at DESC')
    assert_equal test_notes.size, notes.size
    assert_descending_order(notes)
  end
  
  def test_should_retrieve_latest_note_by_user
    notes = Comment.find_notes_by_user_id(@morneau.id, 1)
    test_notes = Comment.find(:all,
                              :conditions => "user_id = #{@morneau.id} AND parent_id IS NULL",
                              :order => 'created_at DESC')
    assert_equal test_notes.first.body, notes.first.body
  end
  
  def test_should_find_all_notes
    notes = Comment.notes
    test_notes = Comment.find(:all, :conditions => 'parent_id IS NULL')
    assert_equal test_notes.size, notes.size
  end
  
  def test_should_find_all_responses
    responses = Comment.responses
    test_responses = Comment.find(:all, :conditions => 'parent_id IS NOT NULL')
    assert_equal responses.size, responses.size
  end
  
  def test_should_find_latest_comment_time_by_story
    time = Comment.find_most_recent_time_by_story_id(@santana_story.id)
    assert_equal @santana_response.created_at.to_s, time.to_s
  end
  
  def test_should_not_find_any_recent_times_by_user_id
    time = Comment.find_most_recent_time_by_story_id(@mauer.id)
    assert_equal Date.new(2007, 1, 1).to_time, time    
  end
  
  def test_should_be_note
    assert @morneau_note.is_note?
  end
  
  def test_should_not_be_note
    assert !@santana_response.is_note?
  end
  
  def test_should_be_response
    assert @santana_response.is_response?
  end
  
  def test_should_not_be_response
    assert !@morneau_note.is_response?
  end
  
  def test_should_have_a_response
    assert @morneau_note.has_response?
  end
  
  def test_should_not_have_a_response
    assert !@morneau_note2.has_response?
  end
  
  protected
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
