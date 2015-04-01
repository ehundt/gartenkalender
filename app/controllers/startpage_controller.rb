class StartpageController < ApplicationController
  load_and_authorize_resource

  def index
   @current_tasks = Task.for_user(current_user)
                        .where('start <= ? AND end >= ?',
                                current_season,
                                current_season)
                        .includes(:plant)
  end

private

  def current_season
    3 # TODO
  end

end
