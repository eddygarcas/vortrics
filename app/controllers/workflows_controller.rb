class WorkflowsController < ApplicationController
	layout 'sidenav'
	before_action :set_workflow, only: [:destroy]
	before_action :team_session
	before_action :admin_user?


	# GET /workflows
	# GET /workflows.json
	def index
		@workflow = current_user.setting.workflow
		redirect_to new_workflow_path and return if current_user.setting.workflow.blank?
	end

	# GET /workflows/new
	def new
		@workflow = Workflow.new
	end

	# DELETE /workflows/1
	# DELETE /workflows/1.json
	def destroy
		@workflow.destroy
		respond_to do |format|
			format.html { redirect_to workflows_url, notice: 'Workflow was successfully destroyed.' }
			format.json { head :no_content }
		end
	end

	private

	# Use callbacks to share common setup or constraints between actions.
	def set_workflow
		@workflow = Workflow.find(params[:id])
	end

	# Never trust parameters from the scary internet, only allow the white list through.
	def workflow_params
		params.require(:workflow).permit(:setting_id, :open, :backlog, :wip, :testing, :done, :flagged)
	end
end
