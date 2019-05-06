class AssesmentsController < ApplicationController
  layout 'sidenav'
  before_action :set_assesment, only: [:show, :edit, :update, :destroy, :answer]
  before_action :team_session


  # GET /assesments
  # GET /assesments.json
  def index
    @assesments = Assesment.all
  end

  def answer
    @answers = @assesment.answers
  end

  # GET /assesments/1
  # GET /assesments/1.json
  def show
  end

  # GET /assesments/new
  def new
    @assesment = Assesment.new
  end

  # GET /assesments/1/edit
  def edit
  end

  # POST /assesments
  # POST /assesments.json
  #It won't aonly create the assesment but also as many blank answers as questions the maturity model has.
  def create
    @assesment = Assesment.new(assesment_params)

    respond_to do |format|
      if @assesment.save
        @assesment.create_answers

        format.html {redirect_to assesments_url, notice: 'Assessment was successfully created.'}
        format.json {render :show, status: :created, location: @assesment}
      else
        format.html {render :new}
        format.json {render json: @assesment.errors, status: :unprocessable_entity}
      end
    end
  end

  # PATCH/PUT /assesments/1
  # PATCH/PUT /assesments/1.json
  def update
    respond_to do |format|
      if @assesment.update(assesment_params)
        format.html {redirect_to @assesment, notice: 'Assessment was successfully updated.'}
        format.json {render :show, status: :ok, location: @assesment}
      else
        format.html {render :edit}
        format.json {render json: @assesment.errors, status: :unprocessable_entity}
      end
    end
  end

  # DELETE /assesments/1
  # DELETE /assesments/1.json
  def destroy
    @assesment.destroy
    respond_to do |format|
      format.html {redirect_to assesments_url, notice: 'Assessment was successfully destroyed.'}
      format.json {head :no_content}
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_assesment
    assesment_id = params[:assesment_id].blank? ? params[:id] : params[:assesment_id]
    @assesment = Assesment.find(assesment_id)
  end

  def set_framework
    @maturity_framework = MaturityFramework.find(params[:maturity_framework_id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def assesment_params
    params.require(:assesment).permit(:id, :name, :date, :team_id, :maturity_framework_id)
  end
end
