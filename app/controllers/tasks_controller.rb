class TasksController < ApplicationController

  before_filter :authenticate_user!

  load_and_authorize_resource

  def show
    @plant = @task.plant
    @help_content_path = "/tasks"
  end

  def new
   @plant = Plant.find(params[:plant_id])
   @repeat_options = Task.repeats
  end

  def edit
    @plant = Plant.find(params[:plant_id])
    @repeat_options = Task.repeats
  end

  def create
    begin_date = Date.new(1, params[:begin_month].to_i, params[:begin_day].to_i)
    end_date   = Date.new(1, params[:end_month].to_i, params[:end_day].to_i)

    if begin_date > end_date
      end_date = end_date.change(year: 2)
    end

    @task = Task.new(task_params.merge( plant_id:   params[:plant_id],
                                        user_id:    current_user.id,
                                        begin_date: begin_date,
                                        end_date:   end_date))
    @task.update(task_params.merge( plant_id:   params[:plant_id],
                                        user_id:    current_user.id,
                                        begin_date: begin_date,
                                        end_date:   end_date))

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
    begin_date = Date.new(1, params[:begin_month].to_i, params[:begin_day].to_i)
    end_date   = Date.new(1, params[:end_month].to_i, params[:end_day].to_i)

    if begin_date > end_date
      end_date = end_date.change(year: 2)
    end

    @task.update(task_params.merge(begin_date: begin_date, end_date: end_date))

    @plant = Plant.find(params[:plant_id])
    redirect_to plant_task_path(@task.plant, @task)
  end

  def destroy
    @task.destroy

    redirect_to Plant.find(params[:plant_id])
  end

  def hide
    @task.update(hide: true)

    if request.xhr?
      render :json => { success: true }
    end
  end

  def unhide
    @task.update(hide: false)

    if request.xhr?
      render :json => { success: true }
    end
  end

private

  def task_params
    params.require(:task).permit(:title, :desc, :start, :stop, :repeat, :plant_id, :user_id, :hide, :begin_date, :end_date)
  end
end
