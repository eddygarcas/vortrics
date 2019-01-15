class QStagesController < ApplicationController
  layout 'sidenav'
  before_action :set_q_stage, only: [:show, :edit, :update, :destroy]
  before_action :team_session,:user_session


  # GET /q_stages
  # GET /q_stages.json
  def index
    @q_stages = QStage.all
    Assesment.new

  end

  # GET /q_stages/1
  # GET /q_stages/1.json
  def show
  end

  # GET /q_stages/new
  def new
    @q_stage = QStage.new
  end

  # GET /q_stages/1/edit
  def edit
  end

  # POST /q_stages
  # POST /q_stages.json
  def create
    @q_stage = QStage.new(q_stage_params)

    respond_to do |format|
      if @q_stage.save
        format.html {redirect_to q_stages_url, notice: 'Stage was successfully created.'}
        format.json { render :show, status: :created, location: @q_stage }
      else
        format.html { render :new }
        format.json { render json: @q_stage.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /q_stages/1
  # PATCH/PUT /q_stages/1.json
  def update
    respond_to do |format|
      if @q_stage.update(q_stage_params)
        format.html { redirect_to @q_stage, notice: 'Q stage was successfully updated.' }
        format.json { render :show, status: :ok, location: @q_stage }
      else
        format.html { render :edit }
        format.json { render json: @q_stage.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /q_stages/1
  # DELETE /q_stages/1.json
  def destroy
    @q_stage.destroy
    respond_to do |format|
      format.html { redirect_to q_stages_url, notice: 'Q stage was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_q_stage
      @q_stage = QStage.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def q_stage_params
      params.require(:q_stage).permit(:name, :value, :level_id)
    end
end
