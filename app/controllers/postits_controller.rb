class PostitsController < ApplicationController
  before_action :set_postit, only: [:show, :edit, :update,:save, :destroy,:move,:vote]

  # GET /postits
  # GET /postits.json
  def index
    @postits = Postit.all
  end

  # GET /postits/1
  # GET /postits/1.json
  def show
  end

  # GET /postits/new
  def new
    @postit = Postit.new
  end

  # GET /postits/1/edit
  def edit
  end

  def move
    @postit.update(postit_params)
    broadcast_actioncable "retrospective","postitMoved", @postit.to_json(include: [:user,comments: {include: :actor }])
    render action: :show
  end

  def vote
    @postit.update(dots: @postit.dots.nil? ? 1 : @postit.dots+1)
    broadcast_actioncable "retrospective","postitVote", @postit.to_json
    render json: :success
  end

  def save
    @postit.update(description: postit_params[:description])
    broadcast_actioncable "retrospective", "savePostit", @postit.to_json
    render json: :success
  end

  # POST /postits
  # POST /postits.json
  def create
    @postit = Postit.new(postit_params)
    @postit.user = current_user

    respond_to do |format|
      if @postit.save
        broadcast_notification @postit
        broadcast_actioncable "retrospective", "createPostit", @postit.to_json(include: [:user,comments: {include: :actor }])
        format.html { redirect_to @postit, notice: 'Postit was successfully created.' }
        format.json { render json: @postit.to_json(include: :user) }
      else
        format.html { render :new }
        format.json { render json: @postit.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /postits/1
  # PATCH/PUT /postits/1.json
  def update
    respond_to do |format|
      if @postit.update(postit_params)
        format.html { redirect_to @postit, notice: 'Postit was successfully updated.' }
        format.json { render :show, status: :ok, location: @postit }
      else
        format.html { render :edit }
        format.json { render json: @postit.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /postits/1
  # DELETE /postits/1.json
  def destroy
    @postit.destroy
    respond_to do |format|
      ActionCable.server.broadcast "retrospective", { commit: 'deletePostit', payload: @postit.to_json }
      format.html { redirect_to postits_url, notice: 'Postit was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_postit
      @postit = Postit.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def postit_params
      params.require(:postit).permit(:text, :position, :dots, :description, :comments, :retrospective_id)
    end
end
