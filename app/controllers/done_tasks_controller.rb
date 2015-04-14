class DoneTasksController < ApplicationController
  before_filter :authenticate_user!

  load_and_authorize_resource

  def create
    @done_task = DoneTask.new(task_id: params[:task_id], season: 2, year: Date.today.year)
    if @done_task.save
      redirect_to root_path
    end
  end

private

  def done_task_params
#    params.require(:task).permit(:task_id)
  end
end
