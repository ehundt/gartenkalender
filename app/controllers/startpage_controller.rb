class StartpageController < ApplicationController
  before_filter :authenticate_user!, only: [:index]

  load_and_authorize_resource

  def index
    unless current_user.first_steps_seen?
      render template: "/first_steps/copy_plant_carousel"
      current_user.update_attribute(:first_steps_seen, true) and return
    else
      if current_user.plants.empty?
        render template: "/startpage/welcome" and return
      else
        @upcoming_tasks = Task.upcoming_tasks_for_user(current_user)
      end
    end
    @help_content_path = "/startpage"
  end

  def first_steps
    @topic = params[:topic]
    unless @topic =~ /^(copy_plant|tasks|comments|new_plant)$/
      @topic = "copy_plant"
    end

    render template: "/first_steps/#{@topic}_carousel"
  end

  def entry
    render layout: "entry", template: "startpage/entry"
  end

  private

  def startpage_params
    params.require(:startpage)
  end
end
