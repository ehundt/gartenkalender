class SeasonsController < ApplicationController

  def new
  end

  def show
#    unless (/^\d+\.\d+$/ =~ params[:season][:latitude] && /^\d+\.\d+$/ =~ params[:season][:longitude])
#      flash[:danger] = "Die phaenologische Jahreszeit ist abhängig vom Standort. Ohne korrekte Längen- und Breiteninformationen kann die Jahreszeit nicht bestimmt werden."
#      redirect_to new_season_path
#    end

    begin
      @season = Season.new( latitude: params[:season][:latitude],
                            longitude: params[:season][:longitude] )

      if @season.valid?
        response = RestClient.get Rails.application.config.phaeno_url,
                  { :params => @season.geolocation,
                    :accept => :json }
        # TODO: error handling
        if response
          result = JSON.parse(response)
          raise if result["error"]
          @season.season         = result["season"]
          @season.plant          = result["plant"]
          @season.station        = result["station"]
          @season.phase          = result["phase"]
          @season.reporting_date = Date.parse(result["reporting_date"])
        end
      else
        raise "Invalid season parameters! Params = #{params.inspect}, season = #{@season.inspect}"
      end

    rescue => ex
      Rails.logger.fatal ex
      flash[:danger] = "Leider ist ein Fehler aufgetreten. Bitte kontaktiere gartenkalender@gmail.com. Vielen Dank."
      redirect_to new_season_path
    end
  end
end
