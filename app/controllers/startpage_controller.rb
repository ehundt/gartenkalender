class StartpageController < ApplicationController
  load_and_authorize_resource

  def index
    unless current_user
      render template: "startpage/logged_out/index"
    else
      @current_tasks = Task.for_user(current_user)
                        .where('start <= ? AND end >= ?',
                                current_season,
                                current_season)
                        .includes(:plant)
    end
  end

private

  def current_season
    3 # TODO
  end

end
