require File.dirname(__FILE__) + '/../test_helper'

class FavoriteTest < ActiveSupport::TestCase
  fixtures :users, :stories

  should_belong_to :user
  should_belong_to :favoritable

  def test_should_not_be_able_to_favorite_oneself
    f = Favorite.create(:user_id => 2, :favoritable_type => 'User', :favoritable_id => 2)
    assert !f.errors.blank?
  end
  
  def test_should_be_able_to_favorite_someone_else
    f = Favorite.create(:user_id => 2, :favoritable_type => 'User', :favoritable_id => 3)
    assert f.errors.blank?
  end

  def test_should_not_be_able_to_favorite_ones_own_story
    u = users(:quentin)
    s = stories(:quentin_story)
    f = Favorite.create(:user => u, :favoritable_type => "Story", :favoritable_id => s.id)
    assert !f.errors.blank?
  end
  
  def test_should_be_able_to_favorite_someone_elses_story
    u = users(:quentin)
    s = stories(:aaron_story)
    f = Favorite.create(:user => u, :favoritable_type => "Story", :favoritable_id => s.id)
    assert f.errors.blank?
  end

end
