class StartpageController < ApplicationController
  load_and_authorize_resource

  def index
    unless current_user
      render template: "startpage/logged_out/index"
    else
      @current_tasks = Task.current_tasks_for_user(current_user)
    end
  end
end
