class CommentsController < ApplicationController
  layout "single_column"
  
  before_filter :comment_body_required, :only => :create
  before_filter :response_body_required, :only => :create_response
  before_filter :parent_id_required, :only => :create_response
  
  # Available via nested routes.  Subclass ala Rails Way if complexity grows.
  def index
    if params[:user_id]
      @user   = User.find(params[:user_id])
      @notes  = @user.notes.not_responses.latest_paged(params[:page])
    else
      @title  = "Recent writing workshop notes"
      @notes  = Comment.not_responses.latest_paged(params[:page]) 
    end
  end
  
  def create
    @comment          = Comment.new(params[:comment])
    @comment.user_id  = current_user.id
    @comment.story_id = params[:story_id]

    if @comment.save
      # TODO Get these into some sweepers, not inline in action
      expire_fragment("home/index/current_user_notes/#{@comment.user_id}")  # Use CommentSweeper wants RESTful
      expire_fragment("home/index")
      expire_fragment("home/logged_in_index")
      redirect_to story_path(params[:story_id], :anchor => "comment_#{@comment.id}")
      return
    end    
    redirect_to story_path(params[:story_id])
  end
  
  def create_response
    @comment           = Comment.new(params["comment_response_#{@parent_id}"])
    @comment.parent_id = @parent_id
    @comment.user_id   = current_user.id
    @comment.story_id  = params[:story_id]

    if @comment.save
      expire_fragment("home/index/current_user_notes/#{@comment.user_id}")  # Use CommentSweeper wants RESTful
      redirect_to story_path(params[:story_id], :anchor => "comment_#{@parent_id}")
      return
    end
    redirect_to story_path(params[:story_id])
  end
  
private

  def parent_id_required
    return render_friendly_404_page unless params[:parent_id]
  end
  
  def comment_body_required
    if params[:comment].empty? || params[:comment][:body].empty?
      flash[:warning] = "You must enter a comment body."
      redirect_to story_path(params[:story_id])
    end
  end

  def response_body_required
    @parent_id = params[:parent_id]
    if params["comment_response_#{@parent_id}"].empty? || params["comment_response_#{@parent_id}"][:body].empty?
      flash[:warning] = "You must enter a response body."
      redirect_to story_path(params[:story_id])
    end
  end
  
end
