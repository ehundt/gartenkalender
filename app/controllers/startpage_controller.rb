class StartpageController < ApplicationController
  before_action :authenticate_user!, only: [:index]

  load_and_authorize_resource

  def index
    @upcoming_tasks = Task.upcoming_tasks_for_user(current_user)
    @help_content_path = "/startpage"
    @my_tasks = true
  end

  def first_steps
    render layout: "first_steps", template: "startpage/first_steps"
  end

  def welcome
    @welcome = true
    render layout: "first_steps", template: "startpage/first_steps"
  end

  def entry
    # meta tags
    set_meta_tags description: "Persönlicher Garten-Organizer mit dynamischer TODO-Liste sowie soziales Netzwerk zum Thema Pflanzenpflege."
    set_meta_tags keywords: "Pflanzen, Pflege, Garten, gärtnern, Gartenpraxis, Pflanzenlexikon, Pflanzenschutz, Netzwerk, Gartenkalender"

    render layout: "entry", template: "startpage/entry"
  end

  private

  def startpage_params
    params.require(:startpage)
  end
end
