class StorySweeper < ActionController::Caching::Sweeper
  observe Story

  def after_create(story)
    expire_cache_for(story)
  end
  
  def after_destroy(story)
    expire_cache_for(story)
  end
  
private

  def expire_cache_for(story)
    expire_fragment("home/index/current_user_stories/#{story.user_id}")
    expire_fragment("home/index/new_releases")
    expire_fragment("home/index")
    expire_fragment("home/logged_in_index")
  end
  
end