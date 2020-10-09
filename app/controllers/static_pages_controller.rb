class StaticPagesController < ApplicationController
  #before_action :authenticate_user!

  def help_page
  end

  def recommendations
  end

  def impressum
  end

  def contact
    unless params[:subject].blank? && params[:text].blank?
      UserMailer.contact_us_email(params[:subject], params[:text], current_user).deliver_now

      if current_user
        flash[:success] = "Vielen Dank! Deine Email wurde versendet. Wir werden uns in Kürze bei Dir melden."
      else
        flash[:success] = "Vielen Dank! Deine Email wurde versendet."
      end
    end
  end
end
