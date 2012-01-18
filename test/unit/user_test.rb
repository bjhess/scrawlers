require File.dirname(__FILE__) + '/../test_helper'

class UserTest < Test::Unit::TestCase
  load_all_fixtures
  
  should_have_many :stories
  should_have_many :notes
  should_have_many :responses
  should_have_many :received_notes, :through => :stories
  should_have_many :invitations
  should_have_many :favoriteds
  should_have_many :fans
  should_have_many :favorites
  should_have_many :favorite_authors, :through => :favorites
  should_have_many :favorite_stories, :through => :favorites

  should_require_attributes :email, :display_name
  should_require_unique_attributes :email, :display_name
  should_ensure_length_in_range :password,     (6..40)
  should_ensure_length_in_range :email,        (6..100)
  should_ensure_length_in_range :new_email,    (6..100)
  should_ensure_length_in_range :display_name, (3..50)
  should_ensure_length_in_range :bio,          (0..100)
  [:email, :new_email].each do |field|
    should_allow_values_for field, 'quentinpart2@example.com'
    should_not_allow_values_for field, '@bj.com', 'bj.com', 'barry@', 'barry@bj.c', 'barry@bj'
  end
  [:display_name, :password].each do |field|
    should_allow_values_for field, '123456', 'abcdef', '12cdef', 'ab3456', 'barry hess', 'barry_hess', 'barry-hess'
    should_not_allow_values_for field, '12345.', '@bcdef', '|2cdef', :message => /can only contain/
  end

  def test_should_create_user
    assert_difference User, :count do
      user = create_user
      assert !user.new_record?, "#{user.errors.full_messages.to_sentence}"
    end
  end

  def test_should_reset_password
    users(:quentin).update_attributes(:password => 'newpassword', :password_confirmation => 'newpassword')
    assert_equal users(:quentin), User.authenticate('quentin@example.com', 'newpassword')
  end

  def test_should_not_rehash_password
    users(:quentin).update_attributes(:email => 'quentin2@example.com')
    assert_equal users(:quentin), User.authenticate('quentin2@example.com', 'password')
  end

  def test_should_authenticate_user
    assert_equal users(:quentin), User.authenticate('quentin@example.com', 'password')
  end

  def test_should_set_remember_token
    users(:quentin).remember_me
    assert_not_nil users(:quentin).remember_token
    assert_not_nil users(:quentin).remember_token_expires_at
  end

  def test_should_unset_remember_token
    users(:quentin).remember_me
    assert_not_nil users(:quentin).remember_token
    users(:quentin).forget_me
    assert_nil users(:quentin).remember_token
  end
  
  
  def test_is_same_user
    assert !users(:quentin).is_same_user?(create_user)
    assert !users(:quentin).is_same_user?(stories(:ten_days_ago_story).user)
    assert users(:quentin).is_same_user?(stories(:yesterdays_story).user)
  end
  
  def test_should_be_activated_user
    users(:quentin).activation_code = nil
    users(:quentin).activated_at = Time.now
    assert users(:quentin).activated?
  end
  
  def test_should_not_be_activated_user
    users(:quentin).activation_code = '1234'
    users(:quentin).activated_at = nil
    assert !users(:quentin).activated?
  end
  
  def test_should_be_authenticated_user
    assert users(:quentin).authenticated?('password')
  end
  
  def test_should_not_be_authenticated_user__when_activated
    assert !users(:quentin).authenticated?('wrong password')
  end
  
  def test_should_not_be_authenticated_user__when_not_activated
    users(:quentin).activation_code = '1234'
    users(:quentin).activated_at = nil
    assert !users(:quentin).authenticated?('password')
  end
  
  def test_activate
    u = create_user
    assert !u.recently_activated?
    assert_nil u.activated_at
    u.activate
    assert u.recently_activated?
    assert_not_nil u.activated_at
    assert_nil u.activation_code
  end
  
  def test_change_email_address
    u = create_user
    assert "quire@example.com", u.email
    assert !u.recently_changed_email?
    assert_nil u.new_email
    assert_nil u.email_activation_code
    u.change_email_address("new_quire@example.com")
    assert u.recently_changed_email?
    assert "new_quire@example.com", u.new_email
    assert_not_nil u.email_activation_code
  end
    
  def test_activate_new_email
    u = create_user
    assert "quire@example.com", u.email
    assert_nil u.new_email
    assert !u.recently_activated_email?
    u.new_email = "new_quire@example.com"
    u.activate_new_email
    assert u.recently_activated_email?
    assert "new_quire@example.com", u.email
    assert_nil u.new_email
    assert_nil u.email_activation_code
  end

  def test_forgot_password
    u = create_user
    assert !u.recently_forgot_password?
    assert_nil u.password_reset_code
    u.forgot_password
    assert u.recently_forgot_password?
    assert_not_nil u.password_reset_code
  end
  
  def test_reset_password
    u = create_user
    assert !u.recently_reset_password?
    u.reset_password
    assert u.recently_reset_password?
    assert_nil u.password_reset_code
  end
  
  def test_should_retrieve_most_recent_received_note_time
    assert_not_equal Time.parse('2007-1-1'), users(:aaron).most_recent_received_note_time
  end
  
  def test_should_retrieve_most_recent_received_note_time__when_no_notes
    assert_equal Time.parse('2007-1-1'), users(:shirley).most_recent_received_note_time
  end
  
  def test_is_favorite_story_should_succeed
    user  = create_user
    story = stories(:yesterdays_story)
    user.favorites.create(:favoritable => story)
    assert_equal true, user.is_favorite_story?(story)
  end
  
  def test_is_favorite_story_should_fail
    user  = create_user
    story = stories(:yesterdays_story)
    assert_equal false, user.is_favorite_story?(story)
  end

  protected
    def create_user(options = {})
      User.create!({ :email                 => 'quire@example.com',
                     :display_name          => 'Quire',
                     :password              => 'quires', 
                     :password_confirmation => 'quires' }.merge(options))
    end

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
