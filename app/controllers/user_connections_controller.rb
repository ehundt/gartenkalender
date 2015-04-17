class UserConnectionsController < ApplicationController
  before_filter :authenticate_user!

  load_and_authorize_resource

  def index
    @requesting_user_connections = current_user.requesting_users
    @sharing_user_connections = current_user.sharing_users
  end

  def new
  end

  def create
    sharing_user = User.where(email: params[:user][:email]).first
    if sharing_user
      if current_user.requesting_users.where(sharing_user_id: sharing_user.id).exists?
        flash[:danger] = "Diese Email Adresse wurde bereits angefragt."
      else
        user_connection = UserConnection.new(sharing_user_id: sharing_user.id, requesting_user_id: current_user.id)
        user_connection.save
      end
      redirect_to action: "index"
    else
      # TODO: open confirmation window: send email and invite?
      flash[:danger] = "Diese Email Adresse konnte nicht gefunden werden."
    end
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
