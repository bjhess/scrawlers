class ContestsController < ApplicationController

  layout "single_column"

  before_filter :set_tab
  before_filter :render_404, :except => [:index, :show]

  def index
    @past_contests  = Contest.find_all_past_contests
    if @active_contest
      @header = @active_contest.title
      fill_entered_stories_lists
      render :action => 'index_with_contest'
    else
      @header = "Contests"
    end  
  end

  def show
    @contest = Contest.find(params[:id])
    @header  = @contest.title
    respond_to do |format|
      format.html
    end
  end

  private

    def set_tab
      @current_tab = :contests
    end

    def fill_entered_stories_lists
      @entered_stories_list_one, @entered_stories_list_two = @active_contest.entered_stories_in_twos
    end
end
