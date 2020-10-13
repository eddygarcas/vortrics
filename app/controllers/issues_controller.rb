class IssuesController < ApplicationController
  layout 'sidenav'
  helper_method :sort_column, :sort_direction
  before_action :set_issue, only: [:show, :destroy,:search]
  before_action :set_sprint, only: [:sprint_issues]
  before_action :team_session

  # GET /issues
  # GET /issues.json
  def index
    @comments = Hash.new
    @sprint = Sprint.new
    @sprint.name = 'All Issues'
    @issues = Issue.joins(:sprint).where('sprints.team_id' => @team.id).paginate(page: params[:page], per_page: 25).order(set_order)
  end

  #GET /issues/sprint/1
  #GET /issues/sprint/1.json
  def sprint_issues
    @issues = @sprint.issues.order(set_order)
    respond_to do |format|
      format.html {render :index}
      format.json {render json: @issues, status: :created}
    end
  end

  # GET /issues/1
  # GET /issues/1.json
  def show
    redirect_to issues_path and return unless @issue.present?
    @comments = service_method(:issue_comments,@issue&.key)
    @attachments = service_method(:issue_attachments,@issue&.key)
    @sprint = Sprint.find(@issue&.sprint_id)
  end


  # GET /issues/new
  def new
    @issue = Issue.new
  end

  #POST /issues/1
  # POST /issues/1.json
  def search
    redirect_to issue_path(@issue) and return unless @issue.blank?

    @sprint = Sprint.new
    @sprint.name = 'All Issues'

    @issues, single = Issue.seach_for 'key', params[:key]
    redirect_to issue_path(@issues.first) and return if single
    render action: 'index' and return unless @issues.empty?

    @issues, single = Issue.seach_for 'components', params[:key]
    redirect_to issue_path(@issues.first) and return if single
    render action: 'index' and return unless @issues.empty?

    @issues, single = Issue.seach_for 'status', params[:key]
    redirect_to issue_path(@issues.first) and return if single
    render action: 'index' and return unless @issues.empty?

    @issues, single = Issue.seach_for 'assignee', params[:key]
    redirect_to issue_path(@issues.first) and return if single
    render action: 'index' and return unless @issues.empty?

    render action: 'index'

  end

  # DELETE /issues/1
  # DELETE /issues/1.json
  def destroy
    @issue.destroy
    respond_to do |format|
      format.html {redirect_to issues_url, notice: 'Issue was successfully destroyed.'}
      format.json {head :no_content}
    end
  end

  private

  def set_order
    order = "#{sort_column} #{sort_direction}"
    order = "CAST(#{sort_column} as INTEGER) #{sort_direction}" if sort_column.eql? 'customfield_11382'
    order
  end

  def sortable_columns
    ['customfield_11382', 'customfield_11802', 'status']
  end

  def sort_column
    sortable_columns.include?(params[:column]) ? params[:column] : 'customfield_11382'
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : 'desc'
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_issue
    @issue = ::Issue.find(params[:id]) unless params[:id].blank?
    @issue = ::Issue.find_by_key(params[:key]) unless params[:key].blank?
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_sprint
    @sprint = Sprint.find(params[:sprint_id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def issue_params
    params.fetch(:issue, :page, :per_page, {})
  end
end
