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
         subject: "Contact us: " + subject.to_str)
  end

  def comment_created_email(plant, commenter)
    @user = plant.creator
    @plant = plant
    @commenter = commenter
    mail(to: @user.email, subject: "Neuer Kommentar")
  end
end
