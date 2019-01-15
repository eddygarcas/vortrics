class MaturityFrameworksController < ApplicationController
  layout 'sidenav'
  before_action :set_maturity_framework, only: [:show, :edit, :update, :destroy]
  before_action :team_session,:user_session

  # GET /maturity_frameworks
  # GET /maturity_frameworks.json
  def index
    @maturity_frameworks = MaturityFramework.all
  end

  # GET /maturity_frameworks/1
  # GET /maturity_frameworks/1.json
  def show
  end

  # GET /maturity_frameworks/new
  def new
    @maturity_framework = MaturityFramework.new
  end

  # GET /maturity_frameworks/1/edit
  def edit
  end

  # POST /maturity_frameworks
  # POST /maturity_frameworks.json
  def create
    @maturity_framework = MaturityFramework.new(maturity_framework_params)

    respond_to do |format|
      if @maturity_framework.save
        format.html {redirect_to maturity_frameworks_url, notice: 'Maturity framework was successfully created.'}
        format.json { render :show, status: :created, location: @maturity_framework }
      else
        format.html { render :new }
        format.json { render json: @maturity_framework.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /maturity_frameworks/1
  # PATCH/PUT /maturity_frameworks/1.json
  def update
    respond_to do |format|
      if @maturity_framework.update(maturity_framework_params)
        format.html { redirect_to @maturity_framework, notice: 'Maturity framework was successfully updated.' }
        format.json { render :show, status: :ok, location: @maturity_framework }
      else
        format.html { render :edit }
        format.json { render json: @maturity_framework.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /maturity_frameworks/1
  # DELETE /maturity_frameworks/1.json
  def destroy
    @maturity_framework.destroy
    respond_to do |format|
      format.html { redirect_to maturity_frameworks_url, notice: 'Maturity framework was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_maturity_framework
      @maturity_framework = MaturityFramework.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def maturity_framework_params
      params.require(:maturity_framework).permit(:name)
    end
end
