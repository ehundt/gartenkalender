class StartpageController < ApplicationController
  load_and_authorize_resource

  def index
    unless current_user
      render template: "startpage/logged_out/index"
    else
      @upcoming_tasks = Task.upcoming_tasks_for_user(current_user)
    end
  end
end
