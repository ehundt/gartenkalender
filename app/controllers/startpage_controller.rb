class StartpageController < ApplicationController
  load_and_authorize_resource

  def index
    unless user_signed_in?
      render template: "/startpage/logged_out/welcome" and return
    else
      if current_user.plants.empty?
        render template: "/first_steps/copy_plant_carousel" and return
      else
        @upcoming_tasks = Task.upcoming_tasks_for_user(current_user)
      end
    end
    @help_content_path = "/startpage"
  end

  def first_steps
    @topic = params[:topic]
    unless @topic =~ /copy_plant|tasks|comment/
      @topic = "copy_plant"
    end

    render template: "/first_steps/#{@topic}_carousel"
  end

  def entry
    render layout: "entry", template: "startpage/entry"
  end

  private

  def startpage_params
    params.require(:startpage).permit(:step)
  end
end
