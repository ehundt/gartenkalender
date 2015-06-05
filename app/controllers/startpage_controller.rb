class StartpageController < ApplicationController
  load_and_authorize_resource

  def index
    if current_user.nil?
      render layout: "logged_out", template: "startpage/logged_out/index"
    else
      @upcoming_tasks = Task.upcoming_tasks_for_user(current_user)
    end
  end
end
