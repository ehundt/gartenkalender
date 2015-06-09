class UserMailer < ApplicationMailer
default from: 'persoenlicher.gartenkalender@gmail.com'

  def invite_email(email, user)
    @user = user
    mail(to: email, subject: 'Persönlicher Gartenkalender')
  end
end
