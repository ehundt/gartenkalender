class CommentsController < ApplicationController
  before_filter :authenticate_user!, except: [:index]

  load_and_authorize_resource

  def index
    @plant = Plant.find(params[:plant_id])
    # TODO: if no plant?
    @comments = @plant.comments.includes(:user)
  end

  def create
    @plant = Plant.find(params[:plant_id])
    unless comment_params[:comment].blank?
      @comment = @plant.comments.create(comment_params.merge(user_id: current_user.id))
      unless @plant.creator == current_user
        UserMailer.comment_created_email(@plant, current_user).deliver_now
      end
    end
    redirect_to plant_comments_path
  end

  def destroy
    @comment.destroy
    redirect_to plant_comments_path
  end

  private

  def comment_params
    params.require(:comment).permit(:comment)
  end

end
