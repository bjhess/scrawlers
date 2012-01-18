class StoriesController < ApplicationController

  layout "single_column"
  # before_filter :login_required, :only => [:save_comment, :save_comment_response]
  before_filter :login_required,      :only => [:new, :create, :edit, :update]
  before_filter :get_active_contest,  :only => [:new, :edit]
  before_filter :find_story,          :only => [:show, :edit, :update, :delete_tag, :add_tag]
  before_filter :story_required,      :only => [:show, :edit, :update, :delete_tag, :add_tag]
  before_filter :author_required,     :only => [:edit, :update, :delete_tag, :add_tag]

  cache_sweeper :story_sweeper, :only => [:create, :destroy]

  # Available via nested routes.  Subclass ala Rails Way if complexity grows.
  def index
    if params[:user_id]
      @user     = User.find(params[:user_id].to_i)
      @stories  = @user.stories.latest_paged(params[:page])
    else
      redirect_to recent_stories_path
    end
  end

  def show
    get_story_information

    @story.update_attribute(:author_viewed_at, Time.now) if @current_user == @story.user
    @fans = @story.fans
    render :layout => "two_column"
  end

  def new
    @story = Story.new
  end

  def create
    @story = current_user.stories.build(params[:story])
    if @story.save
      @story.tag_with(params[:story][:tag_string])  # TODO: Move to model
      @story.save
      #TODO: Move to a BackgroundRb process.
      # TweetApp::ClientContext.status(:post, "New Scrawl: #{@story.title} (#{story_url(@story)})") if "production" == RAILS_ENV
      redirect_to story_path(@story)
    else
      render :action => :new  # TODO: This doesn't result in a nice URL
    end
  end

  def edit
    @story.tag_string = @story.tag_list
    # Redirect if editing is not allowed on this story (wrong user or notes given)
    redirect_to story_path(@story) unless @story.allow_editing?(current_user)
  end

  def update
    if @story.update_attributes(params[:story])
      @story.tag_with(params[:story][:tag_string]) if params[:story][:tag_string] # TODO: Move to model
      @story.save
      redirect_to story_path(@story)
    else
      render :action => :edit  # TODO: This doesn't result in a nice URL
    end
  end

  def preview
    @story = Story.find(params[:id].to_i)
  end

  def recent
    @title       = "Recent 100-word stories"
    @current_tab = :recent
    @stories     = Story.latest_paged(params[:page])
    render :action => :index
  end

  def tagged
    @tag_name = params[:tag_name]
    tag       = Tag.find_by_name(@tag_name)

    redirect_to recent_stories_url and return if tag.nil? || (@stories = tag.tagged).blank?

    @stories.sort! { |story1, story2| story2.published_at <=> story1.published_at }
  end

  # TODO: RESTfulize this method
  def add_tag
    tags = @story.tag_list
    if request.post?
      tags << " " + params[:tag]["name_#{params[:story_id]}"]
      @story.tag_with(tags)
      @story.save
      #seems silly
      @story = Story.find(params[:story_id])
    end
  end

  # TODO: RESTfulize this method
  def cancel_add_tag
    @story_id = params[:story_id]
  end

  # TODO: RESTfulize this method
  def delete_tag
    if request.post?
      @story.delete_tag(params[:tag_name])
      #seems silly
      @story = Story.find(params[:story_id])
    end
  end

  # TODO: RESTfulize this method
  def show_add_tag
    @story_id = params[:story_id]
  end

  # TODO: RESTfulize this method
  def show_comment_response
    @comment_id = params[:comment_id]
  end

  # TODO: RESTfulize this method
  def send_invitation
    @story_id = params[:id]

    # Invitation is sent upon successful invitation creation
    @invite = Invitation.create(:recipient_list => params[:invitation_email],
                               :user_id => current_user.id,
                               :invited_id => @story_id,
                               :invited_type => "Story")

    respond_to do |format|
      format.html {
        ten_recent_stories
        if @invite.valid?
          flash[:notice] = "Thanks for sharing!"
        else
          flash[:notice] = nil
        end
        get_story_information(@story_id)
        render :action => :read_story, :id => @story_id
      }
      format.js { }
    end
  end

private
 
  def find_story
    @story = Story.find((params[:id] || params[:story_id]))
  end 

  def author_required
    return render_friendly_404_page unless @story.author?(current_user)
  end

  def get_story_information(story_id=nil)
    @story = Story.find(story_id) if story_id
    @stories_by_author = Story.find_all_by_user_id(@story.user.id,
                                               :conditions => ["id != ?", @story.id],
                                               :limit => 10,
                                               :order => "published_at DESC")
  end

  def get_active_contest
    @active_contest = Contest.find_active_contest
  end

end
