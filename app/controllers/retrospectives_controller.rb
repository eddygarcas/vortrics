class RetrospectivesController < ApplicationController
  layout 'sidenav'
  before_action :set_retrospective, only: [:show, :destroy, :move]
  before_action :team_session


  # GET /retrospectives
  # GET /retrospectives.json
  def index
    @retrospectives = Retrospective.all
  end

  # GET /retrospectives/1
  # GET /retrospectives/1.json
  def show
  end

  # GET /retrospectives/new
  def new
    @retrospective = Retrospective.new
  end

  # GET /retrospectives/1/edit
  def edit
  end

  def move
    @retrospective.insert_at(retrospective_params[:position].to_i)
    render action: :show
  end
  # POST /retrospectives
  # POST /retrospectives.json
  def create
    @retrospective = Retrospective.new(retrospective_params)
    respond_to do |format|
      if @retrospective.save
        format.html { redirect_to @retrospective, notice: 'Retrospective was successfully created.' }
        format.json { render :show, status: :created, location: @retrospective }
      else
        format.html { render :new }
        format.json { render json: @retrospective.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /retrospectives/1
  # PATCH/PUT /retrospectives/1.json
  def update
    respond_to do |format|
      if @retrospective.update(retrospective_params)
        format.html { redirect_to @retrospective, notice: 'Retrospective was successfully updated.' }
        format.json { render :show, status: :ok, location: @retrospective }
      else
        format.html { render :edit }
        format.json { render json: @retrospective.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /retrospectives/1
  # DELETE /retrospectives/1.json
  def destroy
    @retrospective.destroy
    respond_to do |format|
      format.html { redirect_to retrospectives_url, notice: 'Retrospective was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_retrospective
      @retrospective = Retrospective.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def retrospective_params
      params.require(:retrospective).permit(:name, :position, :team_id)
    end
end
