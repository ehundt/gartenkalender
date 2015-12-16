class DoneTasksController < ApplicationController
  before_filter :authenticate_user!

  load_and_authorize_resource

  def index
    @plant = Plant.find(params[:plant_id])
    @done_tasks = DoneTask.includes(:plant).where("plant_id in (?)", @plant.id).order(date: :desc)
  end

  def edit
    @plant = Plant.find(params[:plant_id])
    @done_task = DoneTask.find(params[:id])
  end

  def create
    dt_params = done_task_params.merge( plant_id: params[:plant_id] )

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

  def update
    @done_task = DoneTask.find(params[:id])

    if @done_task.update(done_task_params)
      flash[:success] = "Notiz erfolgreich gespeichert."
    end

    redirect_to action: :index
  end

  def destroy
    @done_task = DoneTask.find(params[:id])
    @done_task.destroy

    redirect_to request.referer
  end

private

  def done_task_params
    params.require(:done_task).permit(:task_id, :skipped, :notice, :date)
  end
end
