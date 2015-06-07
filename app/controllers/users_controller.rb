class UsersController < ApplicationController
  before_filter :authenticate_user!

  load_and_authorize_resource

  def index
    if params[:search].present?
      search_terms = params[:search].gsub(/\s+/m, ' ').strip.split(" ")
      # TODO: split on spaces
      @users = User.where("first_name IN (?) OR last_name IN (?)", search_terms, search_terms).to_a
    else
      @users = User.all
    end
  end

  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    @user.update(user_params)
    redirect_to @user
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy

    redirect_to users_path
  end

  def download_picture
    @user = User.find(params[:id])
    size = params[:size] || :small
    redirect_to @user.picture.expiring_url(10, size)
  end

  def invite
    UserMailer.invite_email(params[:email], current_user).deliver_now
    # TODO: deliver_later
    flash[:success] = "Vielen Dank! Es wurde eine Einladungs-Email an #{params[:email]} gesendet."
    redirect_to users_path
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :picture, :latitude, :longitude, :admin, :text)
  end
end
