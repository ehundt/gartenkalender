class DoneTasksController < ApplicationController
  before_filter :authenticate_user!

  load_and_authorize_resource

  def create
    dt_params = done_task_params.merge(task_id: params[:task_id], season: Season::current)
    @done_task = DoneTask.new(dt_params)

    if @done_task.save
      if done_task_params[:skipped] == "true"
        flash[:success] = "Aufgabe erfolgreich übersprungen."
      else
        flash[:success] = "Aufgabe erfolgreich erledigt!"
      end
      redirect_to root_path
    end
  end

private

  def done_task_params
    params.permit(:task_id, :skipped)
  end
end
