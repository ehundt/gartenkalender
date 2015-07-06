class CommentsController < ApplicationController
  before_filter :authenticate_user!

  load_and_authorize_resource

  def index
    @plant = Plant.find(params[:plant_id])
    # TODO: if no plant?
    @comments = @plant.comments.includes(:user)
  end

  def create
    @plant = Plant.find(params[:plant_id])
    @comment = @plant.comments.create(comment_params.merge(user_id: current_user.id))
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
