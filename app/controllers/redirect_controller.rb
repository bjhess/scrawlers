class RedirectController < ApplicationController
  def index
    return render_friendly_404_page unless blog_url?

    blog_redirect
  end
end
