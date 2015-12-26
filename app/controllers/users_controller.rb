class UsersController < ApplicationController
  before_filter :authenticate_user!, except: [:download_picture]

  load_and_authorize_resource

  def index
    if params[:search].present?
      search_terms = params[:search].gsub(/\s+/m, ' ').strip.split(" ")
      # TODO: split on spaces
      @users = User.where("first_name IN (?) OR last_name IN (?)", search_terms, search_terms).page params[:page]
    else
      @users = User.all.page params[:page]
    end
  end

  def show
    @user = User.friendly.find(params[:id])
    @help_content_path = "/users"
    @all_plants_count = @user.plants.count
    @public_plants_count = @user.plants.where(public: true).count
    @plants_used_by_others_count = Plant.where(creator: @user).where('user_id != ?', @user.id).count
  end

  def edit
    @user = User.friendly.find(params[:id])
  end

  def update
    @user = User.friendly.find(params[:id])
    @user.update(user_params)
    if current_user.admin?
      @user.admin = (params[:user][:admin] == "1") ? 1 : 0
      @user.save
    end
    redirect_to @user
  end

  def destroy
    @user = User.friendly.find(params[:id])
    @user.destroy

    redirect_to users_path
  end

  def download_picture
    @user = User.friendly.find(params[:id])
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
    params.require(:user).permit(:first_name,
                                 :last_name,
                                 :email,
                                 :picture,
                                 :latitude,
                                 :longitude,
                                 :text) # admin should not be mass assigned!
  end
end
