class PlantsController < ApplicationController
  before_filter :authenticate_user!

  authorize_resource

  def index
    if params[:search].present?
      search = Plant.search do
        fulltext params[:search]
          with(:user_id, current_user.id)
      end
      @plants = search.results
    else
      @plants = current_user.plants.order(:name)
    end
  end

  def show
    @plant = Plant.find(params[:id]) # User should only see plants of himself and his friends'!!!
  end

  def new
    contacts = Contact.confirmed_contacts_for(current_user)
    user_ids = contacts.collect { |c| c.sharing_user_for(current_user).id }
    if params[:search].present?
      search = Plant.search do
        fulltext params[:search]
          without(:user_id, current_user.id)
          with(:user_id, user_ids)
      end
      @plants = search.results
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

private

  def plant_params
    params.require(:plant).permit(:name, :subtitle, :desc, :main_image, :tasks, :active)
  end
end
