class UsersController < ApplicationController
  before_filter :authenticate_user!

  load_and_authorize_resource

  def index
    @users = User.all
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

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :picture, :latitude, :longitude, :admin)
  end
end
