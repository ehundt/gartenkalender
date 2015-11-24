class TaskImagesController < ApplicationController

  before_filter :authenticate_user!

  load_and_authorize_resource

  def create
    @plant = Plant.find(params[:plant_id])
    @task = Task.find(params[:task_id])
    @task_image = TaskImage.new(task_image_params.merge({ task_id: @task.id }))
    @task_image.save
    redirect_to request.referrer
  end

  def update
    @task_image.update(task_image_params)
    redirect_to request.referrer
  end

  def destroy
  end

  def download_task_image
    size = params[:size] ? params[:size] : :medium
    redirect_to @task_image.image.expiring_url(10, size)
  end

private

  def task_image_params
    params.require(:task_image).permit(:image, :title, :desc)
  end
end
