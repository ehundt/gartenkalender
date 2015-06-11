class UserMailer < ApplicationMailer
default from: 'persoenlicher.gartenkalender@gmail.com'

  def invite_email(email, user)
    @user = user
    mail(to: email, subject: 'Persönlicher Gartenkalender')
  end

  def contact_us_email(subject, text, user)
    @user = user
    @text = text
    mail(to: "persoenlicher.gartenkalender@gmail.com",
         from: user.email,
         subject: subject.to_str)
  end
end
