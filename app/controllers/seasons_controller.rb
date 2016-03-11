class SeasonsController < ApplicationController

  def new
  end

  def show
    @season = Season.new( latitude: params[:season][:latitude],
                          longitude: params[:season][:longitude],
                          address: params[:season][:address] )

    if @season.valid?
      begin
        response = RestClient.get Rails.application.config.phaeno_url,
                  { :params => @season.geolocation,
                    :accept => :json }
        if response
          result = JSON.parse(response)
          raise if result["error"]
          @season.season         = result["season"]
          @season.plant          = result["plant"]
          @season.station        = result["station"]
          @season.phase          = result["phase"]
          @season.reporting_date = Date.parse(result["reporting_date"])
          @address               = params[:season][:address]
          @distance              = result["distance"]
        end

        # TODO: get address via gem geokit-rails
        # @latlng = Geokit::LatLng.new(geolocation[:latitude],geolocation[:longitude])
    # res = Geokit::Geocoders::GoogleGeocoder.reverse_geocode [geolocation[:latitude],geolocation[:longitude]].join(",")
    # address = res.full_address

      rescue Errno::ECONNREFUSED => ex
        Rails.logger.fatal "FATAL: #{ex}"
        flash[:danger] = "Der Server antwortet nicht. Bitte kontakiere gartenkalender@gmail.com bei wiederholtem Auftreten. Danke."
        redirect_to new_season_path
      end

    else
      Rails.logger.warn "WARN: #{@season.errors.messages.values.join(", ")}"
      flash[:danger] = "#{@season.errors.messages.values.join(", ")}"
      redirect_to new_season_path
    end
  end
end
