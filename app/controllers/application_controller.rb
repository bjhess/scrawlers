# Filters added to this controller will be run for all controllers in the application.
# Likewise, all the methods added will be available for all controllers.
class ApplicationController < ActionController::Base

  include AuthenticatedSystem
  include ExceptionNotifiable

  before_filter :redirect_all

  # "remember me" functionality for user accounts
  before_filter :redirect_to_blog_if_required
  before_filter :login_from_cookie
  before_filter :set_base_page_title
  before_filter :find_active_contest

  helper :all # include all helpers, all the time
  
  def render_friendly_404_page
    if request.xhr?
      rjs_redirect_to "404.html"
    else
      respond_to do |format|
        format.html { render(:file => "#{RAILS_ROOT}/public/404.html", :status => 404) }
        format.xml  { head 404 }
        format.json { head 404 }
        format.all  { render :nothing => true, :status => 404}
      end
    end
  end

protected

  helper_method :ie6_user?
  def ie6_user?
    request.env["HTTP_USER_AGENT"] &&
      request.env["HTTP_USER_AGENT"][/(MSIE 6|MSIE 5|MSIE 4|MSIE 3)/i]
  end
  
  def story_required
    return render_friendly_404_page unless @story
  end
  
  def redirect_to_blog_if_required
    blog_redirect if blog_url?
  end
  
  def blog_url?
    request.request_uri =~ /^\/blog/ || request.subdomains.include?('blog')
  end
  
  def blog_redirect
    uri_remainder = request.request_uri.gsub(/^\/blog/, '')
    headers["Status"] = "301 Moved Permanently"
    redirect_to "http://thescrawl.com#{uri_remainder}"
  end

private

  def set_base_page_title
    @page_title = 'Scrawlers.com'
  end
  
  def find_active_contest
    @active_contest = Contest.find_active_contest
  end

  def redirect_all
    redirect_to :controller => :home
  end
  
end