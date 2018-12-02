class ReportUsersController < ApplicationController
	def create
       @user = current_user
		@reportUser= ReportUser.create!(report_params)
       redirect_to @user
	 end
	def new
		@reportUser= ReportUser.new
	end
	private
	def report_params
		params.permit(:reporter_id, :reportee_id,:reason,:comment)
	end
end
