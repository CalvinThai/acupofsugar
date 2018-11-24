class UserMailer <ActionMailer::Base
	default from: 'bolendbot@gmail.com'
	def registration_confirmation(user)
		@user = user
		#mail(:to => "#{user.fname} <#{user.email}>", :subject => "Please confirm your registration")
		#mail(:to @user.email, subject: 'Register plz')
		mail to: @user.email, subject: "Regtistration Confirmation for Bolend"
	end 
	def password_reset(user)
		@user = user
		mail to: @user.email, subject: "Bolend Password Reset"
	end

  def new_friend_request(requirer,requiree)
    @requirer = requirer 
    @requiree = requiree
    mail to: @requiree.email, subject: "Bolend: friend request from #{@requirer.fname.capitalize} #{@requirer.lname.capitalize}."
  end
  
  def accept_friend_request(requirer,requiree)
    @requirer = requirer
    @requiree = requiree
    mail to: @requirer.email, subject: "Bolend: #{@requiree.fname.capitalize} #{@requiree.lname.capitalize} have accepted your friend request."
  end
end