class PlantsController < ApplicationController
  before_filter :authenticate_user!

  load_and_authorize_resource

  def index
    # show public plants of somebody else
    if params[:user_id].present?
      @other_user = User.find(params[:user_id])
      unless @other_user.nil?
        @plants = @other_user.plants.where(public: true).order(:name)
      end

    elsif (params[:search_name].present?)
      @searched = true
      @searched_text = params[:search_name]
      search_terms = params[:search_name].split(' ').collect { |term| '%' + term + '%' }
      @searched_plants = Plant.where("name ILIKE ANY (array[?])", search_terms)
                              .where(user_id: current_user.id)
    else
      @plants = current_user.plants.order(:name)
    end
  end

  def show
    @plant = Plant.find(params[:id]) # TODO: make sure user cannot see private plants of other users
    @done_tasks = Array.new()

    @plant.tasks.order(created_at: :desc).each do |task|
      unless task.done_tasks.empty?
        @done_tasks.push(task.done_tasks)
      end
    end
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
    @plant.update(plant_params)
    if request.xhr?
      render :json => { success: true }
    else
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
    params.require(:plant).permit(:name, :subtitle, :desc, :main_image, :tasks, :active, :public, :category)
  end
end
