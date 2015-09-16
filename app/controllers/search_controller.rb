class SearchController < ApplicationController

  def index
    @plants = retrieve_plants()
    if @plants.nil?
      @plants = Plant.where(public: true).order(:cached_votes_total => :desc).page params[:page]
    end
    @inputs = Array.new
    @inputs.push(params[:search_name]) unless params[:search_name].blank?
    @inputs.push(params[:search_category]) if (!params[:search_category].blank? && params[:search_category] != "keine")
    @inputs.push(params[:search_creator]) unless params[:search_creator].blank?

    @searched_for = { :name     => params[:search_name],
                      :category => params[:search_category],
                      :creator  => params[:search_creator] }

    @help_content_path = "/search"
  end

private

  def searched?
    params[:search_name].present? || params[:search_creator].present?
  end

  def search_creator_ids
    if params[:search_creator].present?
      terms = params[:search_creator]
      search_terms = terms.split(' ').collect { |term| '%' + term + '%' }
      creator_ids = User.where("first_name ILIKE ANY (array[?]) OR last_name ILIKE ANY (array[?])",
                               search_terms, search_terms).pluck(:id)
    end
    creator_ids
  end

  def retrieve_plants()
    only_public = params[:search_only_public].present? ? params[:search_only_public].to_i : 1
    creator_ids = search_creator_ids()

    query = Plant.order(cached_votes_total: :desc)

    if params[:search_name].present?
      search_terms = params[:search_name].split(' ').collect { |term| '%' + term + '%' }

      if search_category
        query = query.where("name ILIKE ANY (array[?]) OR category = ?", search_terms, search_category)
      else
        query = query.where("name ILIKE ANY (array[?])", search_terms)
      end

    else # no search name
      if search_category
        query = query.where(category: search_category)
      end
    end

    if only_public == 1
      query = query.where(public: true)
    end

    if creator_ids.present?
      query = query.where("creator_id IN (?)", creator_ids)
    end

    query = query.page params[:page]
    query
  end

  def search_category
    if params[:search_category] != "keine"
      Plant.categories[params[:search_category]]
    end
  end
end
