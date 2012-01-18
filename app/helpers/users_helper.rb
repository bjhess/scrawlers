module UsersHelper
  
  def link_to_notes_for_user_rss(user)
    link_to("Subscribe " +
              image_tag('rss_sm.png', :alt => "Subscribe to notes for #{user.display_name}'s stories") +
    					" to track the latest notes on your stories",
			      { :controller => :feed,
			        :action => :notes_for_author,
			        :id => user.id })
  end
    
  def stories_area(&block)
    if @stories.empty?
      if is_current_user?(@user)
        content_tag(:p) do
          "You have not posted a story. " +
            content_tag(:span, link_to('Scrawl!', new_story_path), :class => 'tool')
        end
      else
        content_tag(:p, "This Scrawler has yet to write a story.")
      end
    else
      block.call
    end
  end
  
  def comments_area(&block)
    if @comments.empty?
      if is_current_user?(@user)
        content_tag(:p) do
          "You have not given any notes. " +
            content_tag(:span, link_to('Read!', recent_stories_path), :class => 'tool')
        end
      else
        content_tag(:p, "This Scrawler has yet to give a note.")
      end      
    else
      block.call
    end
  end
  
  def favorite_author
    favorite = current_user.find_favorite_for_author(@author)
    'Favorite author ' + 
      content_tag(:span, :class => 'delete_tool') do
        link_to_remote('x', :url => author_favorited_url(@author, favorite), :method => :delete)
      end
  end
  
  def make_favorite_author
    link_to_remote("Favorite this author", :url => author_favoriteds_url(@author), :method => :post)
  end
  
  def favorite_author_area
    return "" if :false == current_user || current_user.id == @author.id
    content_tag(:div, :class => "favorite_container") do
      content_tag(:span, :id => dom_id(@author, :favorited), :class => "favorite") do
        current_user.is_favorite_author?(@author) ? favorite_author : make_favorite_author
      end
    end
  end
  
end
