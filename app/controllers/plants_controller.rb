class PlantsController < ApplicationController
  before_filter :authenticate_user!

  authorize_resource

  def index
    @plants = current_user.plants.order(:name)
  end

  def show
    @plant = Plant.find(params[:id]) # TODO: rather only look for current_user's plants
  end

  def new
  end

  def edit
    @plant = Plant.find(params[:id])
  end

  def create
    @plant = current_user.plants.create(plant_params)
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

private

  def plant_params
    params.require(:plant).permit(:name, :subtitle, :desc, :main_image, :tasks, :active)
  end
end
