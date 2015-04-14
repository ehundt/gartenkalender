class TasksController < ApplicationController

  before_filter :authenticate_user!

  load_and_authorize_resource

  def show
    @task = Task.find(params[:id])
    @plant = @task.plant
  end

  def new
   @plant = Plant.find(params[:plant_id])
   @repeat_options = Task.repeats
  end

  def edit
    @task = Task.find(params[:id])
    @plant = Plant.find(params[:plant_id])
    @repeat_options = Task.repeats
  end

  def create
    @task = Task.new(task_params.merge(plant_id: params[:plant_id], user_id: current_user.id))
    @plant = Plant.find(params[:plant_id])

    if @task.save
      flash[:success] = "Die Aufgabe wurde erfolgreich gespeichert."
      redirect_to @plant
    else
      flash[:danger] = "Fehler: Die Aufgabe konnte nicht gespeichert werden."
      redirect_to edit_plant_path(@plant)
    end
  end

  def update
    @task = Task.find(params[:id])
    @task.update(task_params)
    @plant = Plant.find(params[:plant_id])
    redirect_to @plant
  end

  def destroy
    @task = Task.find(params[:id])
    @task.destroy

    redirect_to Plant.find(params[:plant_id])
  end

  def hide
    @task = Task.find(params[:id])
    @task.update(hide: true)

    redirect_to root_url
  end

private

  def task_params
    params.require(:task).permit(:title, :desc, :start, :stop, :repeat, :plant_id, :user_id, :hide)
  end
end
