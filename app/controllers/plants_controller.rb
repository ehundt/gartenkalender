class PlantsController < ApplicationController
  before_filter :authenticate_user!, except: [:show, :download_main_image]

  load_and_authorize_resource

  def index
    @only_public = "0"
    @plants = []

    @filter_options  = [:all, :only_active, :only_public, :only_created]
    @sorting_options = [:name, :cached_votes_total]

    @selected_filter  = params[:filter].present? ? params[:filter] : "all"
    @selected_filter  = @selected_filter.to_sym

    @selected_sorting = params[:sort_by].present? ? params[:sort_by] : "name"
    @selected_sorting = @selected_sorting.to_sym

    # TODO: search should go to a search action
    if (params[:search_name].present?)
      @searched = true
      @searched_text = params[:search_name]
      search_terms = params[:search_name].split(' ').collect { |term| '%' + term + '%' }
      @searched_plants = Plant.where("name ILIKE ANY (array[?]) or subtitle ILIKE ANY (array[?])", search_terms, search_terms)
                              .where(user_id: current_user.id)
      if params[:only_active] == 1
        @searched_plants = @searched_plants.where(active: true)
      end
      @searched_plants = @searched_plants.page params[:page]

    else
      order = params[:order].present? ? params[:order] : "asc"

      @plants = current_user.plants.includes(:tasks, :creator)

      if @selected_filter == :only_public
        @only_public = "1"
        @plants = @plants.where(public: true)
      end

      if @selected_filter == :only_active
        @plants = @plants.where(active: true)
      end

      if @selected_filter == :only_created
        @plants = @plants.where(creator: current_user)
      end

      @plants = @plants.order(@selected_sorting.to_sym => order.to_sym)
                       .page params[:page]
      @plants.to_a
    end

    @help_content_path = "/plants"

    # statistics partial:
    @all_plants_count = current_user.plants.count
    @public_plants_count = current_user.plants.where(public: true).count
    @plants_used_by_others_count = Plant.where(creator: current_user).where('user_id != ?', current_user.id).count

    # meta tags
    @page_description = 'Pflanzenliste.'
  end

  def show
    @plant = Plant.friendly.find(params[:id])
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

    # meta tags
    set_meta_tags description: "#{@plant.name}: Pflegetipps und Infos rund um die Pflanze."
    set_meta_tags keywords:    "#{@plant.name}, #{@plant.subtitle}, #{@plant.category}" + I18n.t("page_keywords")
  end

  def new
  end

  def edit
    @plant = Plant.friendly.find(params[:id])

    if @plant.duration
      if @plant.duration % 7 == 0
        @duration = @plant.duration / 7
        @weeks_or_months = 7
      else
        @duration = @plant.duration / 30
        @weeks_or_months = 30
      end
    end
  end

  def create
    params = plant_params.merge(creator_id: current_user.id)
    @plant = current_user.plants.create(params)

    if @plant.valid?
      flash[:success] = "Pflanze wurde erfolgreich gespeichert."
      redirect_to @plant
     else
      error_message = "Beim Speichern der Pflanze ist ein Fehler aufgetreten: "
      error_message += @plant.errors.full_messages.join(", ")
      flash[:danger] = error_message + "."
      render "new"
    end
  end

  def update
    @plant = Plant.friendly.find(params[:id])

    duration = plant_params["duration"].to_i * plant_params["weeks_or_months"].to_i

    success = true
    unless @plant.update(plant_params.update("duration" => duration).except("weeks_or_months"))
      success = false
      error_message = "Beim Speichern der Pflanze ist ein Fehler aufgetreten: "
      error_message += @plant.errors.full_messages.join(", ")
      flash[:danger] = error_message + "."
    end

    if request.xhr?
      render :json => { success: success }
    else
      redirect_to @plant
    end
  end

  def clone
    @plant = Plant.friendly.find(params[:id])
    if @plant
      redirect_to @plant.clone_for(current_user)
    else
      redirect_to root
    end
  end

  def vote
    @plant = Plant.friendly.find(params[:id])
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
    @plant = Plant.friendly.find(params[:id])
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
    @plant = Plant.friendly.find(params[:id])
    if @plant
      @plant.update(active: true)
    end
    if request.xhr?
      render :json => { success: true }
    end
  end

  def inactivate
    @plant = Plant.friendly.find(params[:id])
    if @plant
      @plant.update(active: false)
    end # TODO
    if request.xhr?
      render :json => { success: true }
    end
  end

  def download_main_image
    @plant = Plant.friendly.find(params[:id])
    size = params[:size] || :small
    redirect_to @plant.main_image.expiring_url(10, size)
  end

  def destroy
    @plant = Plant.friendly.find(params[:id])
    @plant.destroy

    redirect_to plants_path
  end

private

  def plant_params
    # TODO: should public param also be allowed to be mass-assigned?
    params.require(:plant).permit(:name, :subtitle, :desc,
                                  :main_image, :tasks, :active,
                                  :public, :category, :private_notes,
                                  :location, :ph_from, :ph_to, :soil,
                                  :duration, :weeks_or_months)
  end
end
