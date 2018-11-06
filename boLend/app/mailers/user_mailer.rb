class UserMailer <ActionMailer::Base
	default from: 'notifications@example.com'
	 #	def registration_confirmation(user)
	#	@user = user
		##mail(:to => "#{user.fname} <#{user.email}>", :subject => "Please confirm your registration")
		#mail(:to @user.email, subject: 'Register plz')
	#end 

  def welcome_email
    @user = params[:user]
    @url  = 'http://localhost:3000/login'
    mail(to: @user.email, subject: 'Welcome to My Awesome Site')
  end

end