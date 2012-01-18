class FeedController < ApplicationController
  session :off
  
  def stories_by_author
    @latest_story_time = Story.find_most_recent_time_by_user_id(params[:id])
    feed_last_modified_time = Time.rfc2822(request.env["HTTP_IF_MODIFIED_SINCE"]) rescue nil
    if feed_last_modified_time and @latest_story_time == feed_last_modified_time
      # stop full rendering of XML
      render :text => '', :status => 304
    else
      @author = User.find(params[:id])
      @stories = Story.find_all_by_user_id_sorted(params[:id], 15)
      headers['Content-Type'] = 'application/rss+xml'
      headers['Last-Modified'] = @latest_story_time.httpdate
    end
  end
  
  def comments_by_story
    @latest_comment_time = Comment.find_most_recent_time_by_story_id(params[:id])
    feed_last_modified_time = Time.rfc2822(request.env["HTTP_IF_MODIFIED_SINCE"]) rescue nil
    if feed_last_modified_time and @latest_comment_time == feed_last_modified_time
      # stop full rendering of XML
      render :text => '', :status => 304
    else
      @story = Story.find(params[:id])
      @story_author = @story.user
      @comments = Comment.find_all_by_story_id_sorted(params[:id])
      headers['Content-Type'] = 'application/rss+xml'
      headers['Last-Modified'] = @latest_comment_time.httpdate
    end
  end
  
  def notes_for_author
    @author = User.find(params[:id])
    @latest_note_time = @author.most_recent_received_note_time
    feed_last_modified_time = Time.rfc2822(request.env["HTTP_IF_MODIFIED_SINCE"]) rescue nil
    if feed_last_modified_time and @latest_note_time == feed_last_modified_time
      # stop full rendering of XML
      render :text => '', :status => 304
    else
      @comments = @author.received_notes
      headers['Content-Type'] = 'application/rss+xml'
      headers['Last-Modified'] = @latest_note_time.httpdate
    end
  end

end
