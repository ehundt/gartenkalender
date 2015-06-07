class UserMailer < ApplicationMailer
default from: 'elisabeth.hoelscher@gmail.com' # TODO

  def invite_email(email, user)
    @user = user
    mail(to: email, subject: 'Persönlicher Gartenkalender')
  end
end
