class UserMailer < ApplicationMailer
default from: 'elisabeth.hoelscher@gmail.com' # TODO

  def invite_email(email, text, user)
    @user = user
    @text = text
    @url = root_url
    mail(to: email, subject: 'Intelligenter Gartenkalender')
  end
end
