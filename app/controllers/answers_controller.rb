class AnswersController < ApplicationController
	layout 'sidenav'
	before_action :set_answer, only: [:show, :edit, :update, :destroy]
	before_action :set_assesment, only: [:results]
	before_action :team_session, :user_session

	# GET /answers
	# GET /answers.json
	def index
		@answers = Answer.all
	end

	#GET /assesments/1/results
	def results
		@answers = @assesment.answers.all
		respond_to do |format|
			format.html { render :index }
			format.json { render json: @answers }
		end
	end

	# GET /answers/1
	# GET /answers/1.json
	def show
	end

	# GET /answers/new
	def new
		@answer = Answer.new
	end

	# GET /answers/1/edit
	def edit
	end

	# POST /answers
	# POST /answers.json
	def create
		@answer = Answer.new(answer_params)

		respond_to do |format|
			if @answer.save
				format.html { redirect_to @answer, notice: 'Answer was successfully created.' }
				format.json { render :show, status: :created, location: @answer }
			else
				format.html { render :new }
				format.json { render json: @answer.errors, status: :unprocessable_entity }
			end
		end
	end

	# PATCH/PUT /answers/1
	# PATCH/PUT /answers/1.json
	def update
		if @answer.update(answer_params)
			render json: { success: :true, message: @answer.id }
		else
			render json: { success: :false, message: @answer.id }
		end

	end

	# DELETE /answers/1
	# DELETE /answers/1.json
	def destroy
		@answer.destroy
		respond_to do |format|
			format.html { redirect_to answers_url, notice: 'Answer was successfully destroyed.' }
			format.json { head :no_content }
		end
	end

	private

	# Use callbacks to share common setup or constraints between actions.
	def set_assesment
		@assesment = Assesment.find(params[:assesment_id])
	end

	# Use callbacks to share common setup or constraints between actions.
	def set_answer
		@answer = Answer.find(params[:id])
	end

	# Never trust parameters from the scary internet, only allow the white list through.
	def answer_params
		params.require(:answer).permit(:field_type, :text, :value, :question_id, :assesment_id)
	end
end
