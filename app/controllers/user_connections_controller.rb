class UserConnectionsController < ApplicationController
  before_filter :authenticate_user!

  load_and_authorize_resource

  def index
    @requested_connections = current_user.requesting_connections.where(confirmed: nil).to_a
    @requesting_connections = current_user.requested_connections.where(confirmed: nil).to_a
    @sharing_connections = UserConnection.confirmed_connections_for(current_user).to_a
  end

  def new
  end

  def create
    requested_user = User.where(email: params[:user][:email]).first
    if requested_user
      if current_user.requesting_users.where(requested_user_id: requested_user.id).exists?
        flash[:danger] = "Diese Email Adresse wurde bereits angefragt."
      else
        user_connection = UserConnection.new(requested_user_id: requested_user.id, requesting_user_id: current_user.id)
        user_connection.save
      end
    else
      # TODO: open confirmation window: send email and invite?
      flash[:danger] = "Diese Email Adresse konnte nicht gefunden werden."
    end
    redirect_to action: "index"
  end

  def update
    @user_connection = UserConnection.find(params[:id])
    @user_connection.update(user_connection_params)
    redirect_to action: "index"
  end

private

  def user_connection_params
    params.permit(:email, :confirmed)
  end

end
