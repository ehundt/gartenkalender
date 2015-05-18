class DoneTasksController < ApplicationController
  before_filter :authenticate_user!

  load_and_authorize_resource

  def create
    dt_params = done_task_params.merge(task_id: params[:task_id])
    @done_task = DoneTask.new(dt_params)

    if @done_task.save
      if done_task_params[:skipped] == "true"
        flash[:success] = "Aufgabe erfolgreich übersprungen."
      else
        flash[:success] = "Aufgabe erfolgreich erledigt!"
      end
      redirect_to request.referer
    end
  end

  def destroy
    @done_task = DoneTask.find(params[:id])
    plant = @done_task.task.plant
    @done_task.destroy

    redirect_to plant
  end

private

  def done_task_params
    params.permit(:task_id, :skipped)
  end
end
