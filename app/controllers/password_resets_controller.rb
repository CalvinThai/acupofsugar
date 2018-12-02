class PasswordResetsController < ApplicationController
skip_before_action :require_login
	def new
	end

	def create
		user = User.find_by_email(params[:email])
		if user
			user.send_password_reset
			flash[:success_msg] = "Email sent with password reset instrucitons."
			redirect_to login_url
		else
			flash[:failure_msg] = "Email not found"
			render 'new'
		end
	end

	def edit
		@user = User.find_by_password_reset_token!(params[:id])
	end
	def update
		@user = User.find_by_password_reset_token!(params[:id])
		if @user.password_reset_sent_at < 2.hours.ago
			redirect_to new_password_reset_path, :alert => "Password reset has expired."
		elsif @user.update_attributes(params.require(:user).permit(:password, :password_confirmation))
			redirect_to root_url, :notice => "Password has been reset!"
		else
			flash[:failure_msg] = "Passwords do not match/Not minimum 6 characters"
			render :edit
		end
	end

end
