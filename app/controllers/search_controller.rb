class SearchController < ApplicationController

  def index
    @plants = retrieve_searched_plants()
    @inputs = Array.new
    @inputs.push(params[:search_name]) unless params[:search_name].blank?
    @inputs.push(params[:search_category]) if (!params[:search_category].blank? && params[:search_category] != "keine")
    @inputs.push(params[:search_creator]) unless params[:search_creator].blank?
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

  def retrieve_searched_plants()
    only_public = params[:search_only_public].present? ? params[:search_only_public].to_i : 1
    creator_ids = search_creator_ids()


    if params[:search_name].present?
      search_terms = params[:search_name].split(' ').collect { |term| '%' + term + '%' }

      if only_public == 1
        if creator_ids.nil?
          if search_category
            @plants = Plant.where("name ILIKE ANY (array[?]) OR category = ?", search_terms, search_category)
                           .where(public: true)
                           .order(cached_votes_total: :desc)
          else
            @plants = Plant.where("name ILIKE ANY (array[?])", search_terms)
                           .where(public: true)
                           .order(cached_votes_total: :desc)
          end
        else
          if search_category
            @plants = Plant.where("name ILIKE ANY (array[?]) OR category = ?", search_terms, search_category)
                           .where(public: true)
                           .where("creator_id IN (?)", creator_ids)
                           .order(cached_votes_total: :desc)
          else
            @plants = Plant.where("name ILIKE ANY (array[?])", search_terms)
                           .where(public: true)
                           .where("creator_id IN (?)", creator_ids)
                           .order(cached_votes_total: :desc)
          end
        end

      else # not only public
        if creator_ids.nil?
          if search_category
            @plants = Plant.where("name ILIKE ANY (array[?]) OR category = ?", search_terms, search_category)
                           .order(cached_votes_total: :desc)
          else
            @plants = Plant.where("name ILIKE ANY (array[?])", search_terms)
                           .order(cached_votes_total: :desc)
          end
        else
          if search_category
            @plants = Plant.where("name ILIKE ANY (array[?]) OR category = ?", search_terms, search_category)
                           .where("creator_id IN (?)", creator_ids)
                           .order(cached_votes_total: :desc)
          else
            @plants = Plant.where("name ILIKE ANY (array[?])", search_terms)
                           .where("creator_id IN (?)", creator_ids)
                           .order(cached_votes_total: :desc)
          end
        end
      end

    else # no search name
      if only_public
        if creator_ids.nil? # no search name, no creator ids
          if search_category
            @plants = Plant.where(public: true)
                           .where(category: search_category)
                           .order(cached_votes_total: :desc)
          end
        else # only public with creator ids, no search name
           if search_category
            @plants = Plant.where(public: true)
                           .where(category: search_category)
                           .where("creator_id IN (?)", creator_ids)
                           .order(cached_votes_total: :desc)
          else # only public, with creator_ids, no search name, no categories
            @plants = Plant.where(public: true)
                           .where("creator_id IN (?)", creator_ids)
                           .order(cached_votes_total: :desc)
          end
        end
      else # not only public
        if creator_ids.nil? # no search name, no creator ids
          if search_category
            @plants = Plant.where(category: search_category)
                           .order(cached_votes_total: :desc)
          end
        else # with creator ids, no search name
          if search_category
            @plants = Plant.where("creator_id IN (?)", creator_ids)
                           .where(category: search_category)
                           .order(cached_votes_total: :desc)
          else # with creator ids, no search name, no category
            @plants = Plant.where("creator_id IN (?)", creator_ids)
                           .order(cached_votes_total: :desc)
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
