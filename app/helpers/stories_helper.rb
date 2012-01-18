module StoriesHelper

  def get_story_tags(story)
    if(is_current_user?(story.user))
      story.tags.collect{|tag|
          "<nobr><span class='tag'>" +
          link_to(tag.name,
                  :controller => :stories,
                  :action => :tagged,
                  :id => tag.name) +
          " " +
          "<span class='delete_tool'>" +
          link_to_remote("x",
  						:url => {
                           :controller => :stories,
                           :action => :delete_tag,
                           :tag_name => tag.name,
                           :story_id => story.id},
                        :confirm => "Delete \"#{tag.name}\" tag?") +
          "" +
          "</span>" +
          "</span></nobr>"
      }.join(" ") +
      "&nbsp;&nbsp;&nbsp;" +
      link_to_remote("add",
                     :url => { :controller => :stories,
                               :action => :show_add_tag,
                               :story_id => story.id },
                     :html => { :id => "add_tag_#{@story.id}_link" })
    else
      if story.tags.blank?
        "<em>no tags entered</em>"
      else
        story.tags.collect{|tag|
          "<nobr><span class='tag'>" +
          link_to(tag.name,
                  :controller => :stories,
                  :action => :tagged,
                  :id => tag.name) +
          "</span></nobr>"}.join(" ")
      end
    end
  end
  
  def story_show_page?
    "show" == controller.action_name
  end

  def link_to_story_title
    return @story.title if story_show_page?
    link_to(@story.title, story_path(@story))
  end

  def show_preview
    update_page do |page|
      page << "$('story_title_preview').innerHTML = $F('story_title') + \"<div class='author'>by #{current_user.display_name}</div>\""
      # page << "$('story_author_preview').innerHTML = 'submitted by #{current_user.display_name}'"
      page << "$('story_body_preview').innerHTML = $F('story_body').stripTags().simpleFormat()"
      page << "$('story_tag_string_preview').innerHTML = $F('story_tag_string')"
      page << "$('story_word_count_preview').innerHTML = $F('story_body').wordCount()"
      page[:write_form].hide
      page[:form_note].hide
      page[:write_preview].show
    end
  end
  
  def hide_preview
    update_page do |page|
      page[:write_preview].hide
      page[:write_form].show
      page[:form_note].show
      page << "$$('.form_note').each(function(e) { e.show(); })"
    end
  end
  
  def word_count_observer
    content_tag(:script, :type => 'text/javascript') do
      <<-JS
      updateWordCount();
      Event.observe(window, 'load',function() {
        Event.observe($('story_body'), 'keyup', updateWordCount);
      }, false);
      JS
    end
  end
  
  def scrawl_button_and_spinner
    content_tag(:button, 'Scrawl!', :type => 'submit') +
      image_tag('spinner.gif', :class => 'spinner', :style => 'display:none;')
  end
  
  def favorite_story
    favorite = current_user.find_favorite_for_story(@story)
    content_tag(:span) do
      'Favorite story ' +
      content_tag(:span, :class => "delete_tool") do
        link_to_remote('x', :url => story_favorited_url(@story, favorite), :method => :delete)
      end
    end
  end
  
  def make_favorite_story
    content_tag(:span) do
      link_to_remote("Favorite this story", :url => story_favoriteds_url(@story), :method => :post)
    end
  end
  
  def favorite_story_area
    return "" if :false == current_user || current_user.id == @story.user_id
    content_tag(:div, :id => dom_id(@story, :favorited), :class => "favorite") do
      current_user.is_favorite_story?(@story) ? favorite_story : make_favorite_story
    end
  end

end
