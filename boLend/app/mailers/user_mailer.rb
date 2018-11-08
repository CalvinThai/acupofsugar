class UserMailer <ActionMailer::Base
	default from: 'bolendbot@gmail.com'
	def registration_confirmation(user)
		@user = user
		#mail(:to => "#{user.fname} <#{user.email}>", :subject => "Please confirm your registration")
		#mail(:to @user.email, subject: 'Register plz')
		mail to: @user.email, subject: "Regtistration Confirmation for Bolend"
	end 


end