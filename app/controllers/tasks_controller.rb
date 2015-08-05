class TasksController < ApplicationController

  before_filter :authenticate_user!

  load_and_authorize_resource

  def index
    @plant = Plant.find(params[:plant_id])
    @help_content_path = "/tasks"
  end

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

    # # including e.g. "End of August"
    # end_month = params[:end_month].to_i
    # case params[:end_day].to_i
    # when 1
    #   end_day = 10
    # when 10
    #   end_day = 20
    # when 20
    #   end_day = 1
    #   end_month += 1
    # end

    # if end_month == 13
    #   end_month = 1
    # end
    # end_date = Date.new(1, end_month, end_day)

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
    #end_date   = Date.new(1, params[:end_month].to_i, params[:end_day].to_i)

    # including e.g. "End of August"
    end_month = params[:end_month].to_i
    case params[:end_day].to_i
    when 1
      end_day = 10
    when 10
      end_day = 20
    when 20
      end_day = 1
      end_month += 1
    end

    if end_month == 13
      end_month = 1
    end
    end_date = Date.new(1, end_month, end_day)

    if begin_date > end_date
      end_date = end_date.change(year: 2)
    end

    @task.update(task_params.merge(begin_date: begin_date, end_date: end_date))

    @plant = Plant.find(params[:plant_id])
    redirect_to plant_tasks_path(@task.plant)
  end

  def destroy
    @task.destroy

    redirect_to request.referer
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
