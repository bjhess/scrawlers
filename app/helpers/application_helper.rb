module ApplicationHelper

  def stylesheet(*files)
    content_for(:head) { stylesheet_link_tag(*files) }
  end
  
  def title(page_title)
    content_for(:title) { page_title + " : Scrawlers" }
  end
  
  def help_email_link
    "<a href='mailto:help@scrawlers.com'>email us</a>"
  end

  def feedback_email_link
    "<a href='mailto:feedback@scrawlers.com'>email us</a>"
  end

  def get_login_links
    ""
  end
  
  def twitter_link(text)
    link_to(text || image_tag('scrawlers_twitter.gif'), "http://twitter.com/scrawlers", :target => "_blank")
  end

  def highlight_if(condition)
    if condition
      content_tag(:span, yield, :class => 'highlight')
    else
      yield
    end
  end

  def is_current_user?(user)
    user && user.is_same_user?(current_user)
  end

  def link_to_user_profile(user)
    link_to(user.display_name, user_path(user))
  end

  def link_to_user_rss(user)
    link_to(image_tag('rss.png', :alt => "Subscribe to #{user.display_name}'s stories"),
			      { :controller => :feed,
			        :action => :stories_by_author,
			        :id => user.id },
			      { :class => 'image' })
  end

  def link_to_story_rss(story)
    link_to(image_tag('rss.png', :alt => "Subscribe to discussion of \"#{story.title}\""),
			      { :controller => :feed,
			        :action => :comments_by_story,
			        :id => story.id },
			      { :class => 'image' })
  end

  def set_focus_to_id(id)
    javascript_tag("if($('#{id}')) $('#{id}').focus()")
  end

  def time_ago(timestamp)
    time_ago_in_words(timestamp) + " ago"
  end

  def user_possessive(user)
    if is_current_user?(user)
      "My"
    else
      "#{user.display_name}'s"
    end
  end

  def windowed_pagination_links(pagingEnum, options)
    link_to_current_page = options[:link_to_current_page]
    always_show_anchors = options[:always_show_anchors]
    padding = options[:window_size]

    current_page = pagingEnum.page
    html = ''

    #Calculate the window start and end pages
    padding = padding < 0 ? 0 : padding
    first = pagingEnum.page_exists?(current_page  - padding) ? current_page - padding : 1
    last = pagingEnum.page_exists?(current_page + padding) ? current_page + padding : pagingEnum.last_page

    # Print start page if anchors are enabled
    html << yield(1) if always_show_anchors and not first == 1

    # Print window pages
    first.upto(last) do |page|
      (current_page == page && !link_to_current_page) ? html << page : html << yield(page)
    end

    # Print end page if anchors are enabled
    html << yield(pagingEnum.last_page) if always_show_anchors and not last == pagingEnum.last_page
    html
  end

  def sidebar_area(&block)
    content_for(:sidebar, nil, &block)
  end

  def header_area
    yield if @header
  end

  def edit_own_bio_link_if_needed
    '(' + link_to('create bio', update_profile_path) + ')' if (@author == current_user) && !@author.has_bio?
  end

  def clear_both
    "<div style='clear:both;'></div>"
  end

  def show_div(div)
    update_page do |page|
      page.visual_effect(:toggle_blind, div)
    end
  end
  
  def blog_url
    "http://thescrawl.com"
  end

end
