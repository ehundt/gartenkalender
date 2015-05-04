class PlantsController < ApplicationController
  before_filter :authenticate_user!

  load_and_authorize_resource

  def index
    if params[:user_id].present?
      @friend = User.find(params[:user_id])
      @plants = @friend.plants.order(:name) # unless @friend.nil?
    else

      if params[:search].present?
        @searched_plants = current_user.plants.where(name: params[:search]).order(:name)
        # when using solr
        # search = Plant.search do
        #   fulltext params[:search]
        #     with(:user_id, current_user.id)
        # end
        # @searched_plants = search.results
        @search_text = params[:search]
      end

      if @searched_plants.blank?
        @plants = current_user.plants.order(:name)
      end
    end
  end

  def show
    @plant = Plant.find(params[:id]) # User should only see plants of himself and his friends'!!!
    @done_tasks = Array.new()
    @plant.tasks.order(updated_at: :desc).each do |task|
      unless task.done_tasks.empty?
        @done_tasks.push(task.done_tasks)
      end
    end
  end

  def new
    contacts = Contact.confirmed_contacts_for(current_user)
    user_ids = contacts.collect { |c| c.sharing_user_for(current_user).id }
    if params[:search].present?
      # TODO: security issue?? params[:search]???
      @plants = Plant.where(name: params[:search]).where('user_id in (?)', user_ids)
      # search = Plant.search do
      #   fulltext params[:search]
      #     without(:user_id, current_user.id)
      #     with(:user_id, user_ids)
      # end
# TODO: add search!
#      @plants = search.results
    end
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
    redirect_to @plant
  end

  def destroy
    @plant = Plant.find(params[:id])
    @plant.destroy

    redirect_to plants_path
  end

  def clone
    @plant = Plant.find(params[:id])
    if @plant
      redirect_to @plant.clone_for(current_user)
    else
      redirect_to root
    end
  end

  # TODO: ajax call, routes, etc.
  def vote
    @plant = Plant.find(params[:id])
    if @plant
      if plant_params[:vote] == "like"
        @plant.liked_by current_user
      elsif plant_params[:vote] == "dislike"
        @plant.disliked_by current_user
      end
    end
  end

private

  def plant_params
    params.require(:plant).permit(:name, :subtitle, :desc, :main_image, :tasks, :active, :vote)
  end
end
