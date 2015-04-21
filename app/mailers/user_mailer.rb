class UserMailer < ApplicationMailer
default from: 'elisabeth.hoelscher@gmail.com' # TODO

  def invite_email(user)
    @user = user
    @url  = 'http://example.com/login'
    mail(to: @user.email, subject: 'Welcome to My Awesome Site')
  end
end
