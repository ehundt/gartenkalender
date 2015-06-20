class PlantsController < ApplicationController
  before_filter :authenticate_user!, except: [:show, :download_main_image]

  load_and_authorize_resource

  def index
    @only_public = "0"
    @plants = []
    if (params[:search_name].present?)
      @searched = true
      @searched_text = params[:search_name]
      search_terms = params[:search_name].split(' ').collect { |term| '%' + term + '%' }
      @searched_plants = Plant.where("name ILIKE ANY (array[?])", search_terms)
                              .where(user_id: current_user.id)
    else
      @plants = current_user.plants

      if (params[:only_public].present? && params[:only_public] == "1")
        @only_public = "1"
        @plants = @plants.where(public: true)
      end

      sort_by = params[:sort_by].present? ? params[:sort_by] : "name"
      order = params[:order].present? ? params[:order] : "asc"

      @plants = @plants.order(sort_by.to_sym => order.to_sym)
    end
    @help_content_path = "/plants"
  end

  def show
    @plant = Plant.find(params[:id])
    @done_tasks = Array.new()

    # TODO: tasks sortieren nach Datum unabhängig vom Jahr: Januar, Februar, etc.

    if current_user
      @plant.tasks.each do |task|
        unless task.done_tasks.empty?
          @done_tasks.push(task.done_tasks.to_a)
        end
      end
      @done_tasks.flatten.sort! { |done1, done2| done1.date <=> done2.date }
    end
    @help_content_path = "/plants"
  end

  def new
  end

  def edit
    @plant = Plant.find(params[:id])
  end

  def create
    params = plant_params.merge(creator_id: current_user.id)
    @plant = current_user.plants.create(params)
    if @plant.save
      flash[:success] = "Pflanze wurde erfolgreich gespeichert."
      redirect_to @plant
    else
      flash[:danger] = 'Beim Speichern der Pflanze ist ein Fehler aufgetreten.'
      render "new"
    end
  end

  def update
    @plant = Plant.find(params[:id])

    if @plant.update(plant_params)
      success = true
    end

    if request.xhr?
      render :json => { success: success }
    else
      unless success
        flash[:danger] = "Konnte die Pflanze leider nicht speichern: $!"
      end
      redirect_to @plant
    end
  end

  def clone
    @plant = Plant.find(params[:id])
    if @plant
      redirect_to @plant.clone_for(current_user)
    else
      redirect_to root
    end
  end

  def vote
    @plant = Plant.find(params[:id])
    success = false
    if @plant && @plant.user_id != current_user
      @plant.liked_by current_user
      success = true
    end
    if request.xhr?
      render :json => { success: success }
    else
      redirect_to request.referer
    end
  end

  def unvote
    @plant = Plant.find(params[:id])
    success = false
    if (@plant && current_user.voted_for?(@plant))
      @plant.unliked_by current_user
      success = true
    end
    if request.xhr?
      render :json => { success: success }
    else
      redirect_to request.referer
    end
  end

  def activate
    @plant = Plant.find(params[:id])
    if @plant
      @plant.update(active: true)
    end
    if request.xhr?
      render :json => { success: true }
    end
  end

  def inactivate
    @plant = Plant.find(params[:id])
    if @plant
      @plant.update(active: false)
    end # TODO
    if request.xhr?
      render :json => { success: true }
    end
  end

  def download_main_image
    @plant = Plant.find(params[:id])
    size = params[:size] || :small
    redirect_to @plant.main_image.expiring_url(10, size)
  end

  def destroy
    @plant = Plant.find(params[:id])
    @plant.destroy

    redirect_to plants_path
  end

private

  def plant_params
    params.require(:plant).permit(:name, :subtitle, :desc,
                                  :main_image, :tasks, :active,
                                  :public, :category, :private_notes,
                                  :location, :ph, :soil)
  end
end
