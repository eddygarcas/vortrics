class CommentsController < ApplicationController
  include ApplicationHelper

  layout 'sidenav'
  before_action :set_advice, only: [:show, :edit]
  before_action :set_comment, only: [:destroy]
  before_action :team_session, append_after_action: :set_advice

  # GET /comments
  # GET /comments.json
  def index
    @comments = Comment.all
  end

  # GET /comments/1
  # GET /comments/1.json
  def show
    @comment = Comment.new
  end

  # GET /comments/new
  def new
    @comment = Comment.new
  end

  # GET /comments/1/edit
  def edit
  end

  # POST /comments
  # POST /comments.json
  def create
    @comment = Comment.new(comment_params)
    @comment.actor = current_user
    respond_to do |format|
      if @comment.save
        broadcast_notification @comment
        broadcast_actioncable("retrospective", "saveComment", @comment.to_json(include: :actor)) unless @comment.postit_id.blank?
        format.html { redirect_to comment_path(@comment.advice_id) }
        format.json { render :show, status: :created, location: @comment }
      else
        format.html { redirect_to advices_path, error: 'Unable to store the comment, please try later.' }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /comments/1
  # PATCH/PUT /comments/1.json
  def update
    respond_to do |format|
      if @comment.update(comment_params)
        format.html { redirect_to @comment }
        format.json { render :show, status: :ok, location: @comment }
      else
        format.html { render :edit }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /comments/1
  # DELETE /comments/1.json
  def destroy
    @comment.destroy
    respond_to do |format|
      broadcast_actioncable("retrospective", "deleteComment", @comment.to_json(include: :actor)) unless @comment.postit_id.blank?
      format.html { redirect_to comment_path(@comment.advice_id) }
      format.json { head :no_content }
    end
  end

  def comments_by_board
    board_id = params[:board_id]
    render json: service_method(:bugs_first_comments,boardid: board_id, options: {fields: vt_jira_issue_fields, maxResults: 400})
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_advice
      @advice = Advice.find(params[:id])
      @team = @advice.teams.first
    end

    def set_comment
      @comment = Comment.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def comment_params
      params.require(:comment).permit(:description,:advice_id,:postit_id)
    end
end
