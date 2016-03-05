class SeasonsController < ApplicationController

  def new
  end

  def show
#    unless (/^\d+\.\d+$/ =~ params[:season][:latitude] && /^\d+\.\d+$/ =~ params[:season][:longitude])
#      flash[:danger] = "Die phaenologische Jahreszeit ist abhängig vom Standort. Ohne korrekte Längen- und Breiteninformationen kann die Jahreszeit nicht bestimmt werden."
#      redirect_to new_season_path
#    end

    @season = Season.new( latitude: params[:season][:latitude],
                         longitude: params[:season][:longitude] )

    if @season.valid?
      begin
        response = RestClient.get Rails.application.config.phaeno_url,
                  { :params => @season.geolocation,
                    :accept => :json }
        # TODO: error handling
        if response
          result = JSON.parse(response)
# TODO: better error handling!
          @error          = result["error"]
          @season.season         = result["season"]
          @season.plant          = result["plant"]
          @season.station        = result["station"]
          @season.phase          = result["phase"]
          @season.reporting_date = result["reporting_date"]
        end

      rescue => ex
        Rails.logger.fatal ex
        flash[:danger] = "Leider ist ein Fehler aufgetreten. Bitte kontaktiere gartenkalender@gmail.com bei wiederholtem Auftreten des Fehlers."
        redirect_to new_season_path
      end
    else
      flash[:danger] = "Fehler: #{@season.errors.messages}"
    end


    require 'logger'
    Logger.new("log/debug.log").debug(response.inspect)
  end
end
