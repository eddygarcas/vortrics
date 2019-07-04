class AdvicesController < ApplicationController
  layout 'sidenav'
  before_action :team_session
  before_action :set_advice, only: [:show, :edit, :update, :destroy]

  # GET /advices
  # GET /advices.json
  def index
    return if @team.blank?
    ScrumMetrics.config[:advices].each_key do |key|
      @team.advices.create_by_key(key) if (@team.respond_to?(key) && @team.send(key))
    end
    @advices = @team.advices.reject(&:read?)
    @advice = Advice.new
  end

  # GET /advices/1
  # GET /advices/1.json
  def show
  end

  # GET /advices/new
  def new
    @advice = Advice.new
  end

  # GET /advices/1/edit
  def edit
  end

  #POST /advices/mark_as_read
  def mark_as_read
    @team.advices.update_all(read: true)
    render json: { success: :true }

  end

  # POST /advices
  # POST /advices.json
  def create
    respond_to do |format|
      if @team.advices.create_from_params(advice_params)
        format.html { redirect_to advices_path, notice: 'Advice was successfully created.' }
        format.json { render :show, status: :created, location: @advice }
      else
        format.html { redirect_to advices_path, error: 'Was unable to store the advice.' }
        format.json { render json: @advice.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /advices/1
  # PATCH/PUT /advices/1.json
  def update
    respond_to do |format|
      if @advice.update(advice_params)
        format.html { redirect_to @advice, notice: 'Advice was successfully updated.' }
        format.json { render :show, status: :ok, location: @advice }
      else
        format.html { render :edit }
        format.json { render json: @advice.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /advices/1
  # DELETE /advices/1.json
  def destroy
    @advice.destroy
    respond_to do |format|
      format.html { redirect_to advices_url, notice: 'Advice was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_advice
      @advice = Advice.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def advice_params
      params.require(:advice).permit(:advice_type,:subject,:description,:read,:completed)
    end
end
