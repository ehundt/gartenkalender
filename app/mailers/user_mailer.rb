class UserMailer < ApplicationMailer
default from: 'persoenlicher.gartenkalender@gmail.com'

  def invite_email(email, user)
    @user = user
    mail(to: email, subject: 'Mein Garten')
  end

  def contact_us_email(subject, text, user)
    @text = text
    if user
      @user_name = "#{user.display_name} ( #{user.id} )"
      from_email = user.email
    else
      @user_name = "Anonym"
      from_email = "persoenlicher.gartenkalender@gmail.com"
    end

    mail(to:      "persoenlicher.gartenkalender@gmail.com",
         from:    from_email,
         subject: "Contact us: " + subject.to_str)
  end

  def comment_created_email(plant, receiver, commenter)
    @user = receiver
    @plant = plant
    @commenter = commenter
    mail(to: @user.email, subject: "Neuer Kommentar")
  end
end
