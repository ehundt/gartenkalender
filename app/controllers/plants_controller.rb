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

    elsif (params[:search_name].present? || params[:search_creator].present? || params[:search_category].present?)
      @searched_plants = retrieve_searched_plants()
      @searched = true
      @search_inputs = Array.new
      @search_inputs.push(params[:search_name]) if params[:search_name] != ""
      @search_inputs.push(params[:search_category]) if params[:search_category] != "keine"
      @search_inputs.push(params[:search_creator]) if params[:search_creator] != ""
    else
      @plants = current_user.plants.order(:name)
    end
  end

  def show
    @plant = Plant.find(params[:id]) # User should only see plants of himself and his friends'!!!
    @done_tasks = Array.new()
    @plant.tasks.order(created_at: :desc).each do |task|
      unless task.done_tasks.empty?
        @done_tasks.push(task.done_tasks)
      end
    end
  end

  def new
    retrieve_searched_plants()

    if (searched? && @plants.empty?)
      flash[:danger] = "Es wurde keine Pflanze gefunden."
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
    if request.xhr?
      render :json => { success: true }
    else
      redirect_to @plant
    end
  end

  def search
    render "search_form"
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
      @plant.liked_by current_user
    end
    redirect_to @plant
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

  def searched?
    params[:search_name].present? || params[:search_creator].present?
  end

  def search_creator_ids
    my_plants = params[:search_my_plants].present? ? params[:search_my_plants] : 0
    if my_plants == 1
      creator_ids = [current_user.id]

    elsif params[:search_creator].present?
      terms = params[:search_creator]
      search_terms = terms.split(' ').collect { |term| '%' + term + '%' }
      creator_ids = User.where.not(id: current_user.id)
                        .where("first_name ILIKE ANY (array[?]) OR last_name ILIKE ANY (array[?])",
                               search_terms, search_terms).pluck(:id)
    end
    creator_ids
    # TODO: search for plants without my own!!
  end

  def retrieve_searched_plants()
    only_public = params[:search_only_public].present? ? params[:search_only_public] : 1
    creator_ids = search_creator_ids()

    only_my_plants = params[:search_my_plants].present? ? params[:search_my_plants] : 0

    if params[:search_name].present?
      # TODO: security issue?? params[:search]???
      search_terms = params[:search_name].split(' ').collect { |term| '%' + term + '%' }

      if only_public == 1
        if creator_ids.nil?
          if search_category
            @plants = Plant.where("name ILIKE ANY (array[?])", search_terms)
                           .where(public: true)
                           .where(category: search_category)
          else
            @plants = Plant.where("name ILIKE ANY (array[?])", search_terms)
                           .where(public: true)
          end
        else
          if search_category
            @plants = Plant.where("name ILIKE ANY (array[?])", search_terms)
                           .where(public: true)
                           .where("creator_id IN (?)", creator_ids)
                           .where(category: search_category)
          else
            @plants = Plant.where("name ILIKE ANY (array[?])", search_terms)
                           .where(public: true)
                           .where("creator_id IN (?)", creator_ids)
          end
        end

      else # not only public
        if creator_ids.nil?
          if search_category
            @plants = Plant.where("name ILIKE ANY (array[?])", search_terms)
                           .where(category: search_category)
          else
            @plants = Plant.where("name ILIKE ANY (array[?])", search_terms)
          end
        else
          if search_category
            @plants = Plant.where("name ILIKE ANY (array[?])", search_terms)
                           .where("creator_id IN (?)", creator_ids)
                           .where(category: search_category)
          else
            @plants = Plant.where("name ILIKE ANY (array[?])", search_terms)
                           .where("creator_id IN (?)", creator_ids)
          end
        end
      end

    else # no search name
      if only_public
        if creator_ids.nil? # no search name, no creator ids
          if search_category
            @plants = Plant.where(public: true)
                           .where(category: search_category)
          else
            require 'logger'
            Logger.new("log/debug.log").debug("yes, i am right")
          end
        else # only public with creator ids, no search name
           if search_category
            @plants = Plant.where(public: true)
                           .where(category: search_category)
                           .where("creator_id IN (?)", creator_ids)
          else # only public, with creator_ids, no search name, no categories
            @plants = Plant.where(public: true)
                           .where("creator_id IN (?)", creator_ids)
          end
        end
      else # not only public
        if creator_ids.nil? # no search name, no creator ids
          if search_category
            @plants = Plant.where(category: search_category)
          end
        else # with creator ids, no search name
          if search_category
            @plants = Plant.where("creator_id IN (?)", creator_ids)
                           .where(category: search_category)
          else # with creator ids, no search name, no category
            @plants = Plant.where("creator_id IN (?)", creator_ids)
          end
        end
      end
    end
    @plants
  end

  def search_category
    if params[:search_category] != "keine"
      Plant.categories[params[:search_category]]
    end
  end
end
