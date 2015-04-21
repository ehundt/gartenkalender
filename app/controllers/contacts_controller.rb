class ContactsController < ApplicationController
  before_filter :authenticate_user!

  load_and_authorize_resource

  def index
    @requesting_contacts = current_user.requesting_contacts.where(confirmed: nil).to_a
    @requested_contacts = current_user.requested_contacts.where(confirmed: nil).to_a
    @sharing_contacts = Contact.confirmed_contacts_for(current_user).to_a
  end

  def new
  end

  def create
    requested_user = User.where(email: params[:user][:email]).first
    if requested_user
      ids = [requested_user.id, current_user.id]
      if Contact.where('requested_user_id IN (?) AND requesting_user_id IN (?)', ids, ids).exists?
        flash[:danger] = "Dieser Kontakt existiert bereits."
      else
        contact = Contact.new(requested_user_id: requested_user.id, requesting_user_id: current_user.id)
        contact.save
      end
    else
# TODO      UserMailer.invite_email(current_user).deliver_later # TODO: must be requested_user instead!!

      # TODO: open confirmation window: send email and invite?
      flash[:danger] = "Diese Email Adresse konnte nicht gefunden werden."
    end
    redirect_to action: "index"
  end

  def update
    @contact = Contact.find(params[:id])
    @contact.update(contact_params)
    redirect_to action: "index"
  end

private

  def contact_params
    params.permit(:email, :confirmed)
  end

end
