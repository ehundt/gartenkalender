class TasksController < ApplicationController
  def index
    @tasks = task.all
  end

  def show
    @task = task.find(params[:id])
  end

  def new
   @plant = Plant.find(params[:plant_id])
   @start_options = Task.starts
   @end_options = Task.ends
   @repeat_options = Task.repeats
  end

  def edit
    @task = Task.find(params[:id])
    @plant = Plant.find(params[:plant_id])
    @start_options = Task.starts
    @end_options = Task.ends
    @repeat_options = Task.repeat
  end

  def create
    @task = Task.new(task_params.merge(plant_id: params[:plant_id]))
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

private

  def task_params
    params.require(:task).permit(:title, :desc, :end, :repeat, :start, :plant_id)
  end
end
