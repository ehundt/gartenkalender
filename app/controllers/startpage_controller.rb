class StartpageController < ApplicationController
  load_and_authorize_resource

  def index
    unless user_signed_in?
      render template: "/startpage/logged_out/welcome" and return
    else
      @upcoming_tasks = Task.upcoming_tasks_for_user(current_user)
    end
    @help_content_path = "/startpage"
  end

  def entry
    render layout: "entry", template: "startpage/entry"
  end
end
