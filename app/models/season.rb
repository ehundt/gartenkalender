class Season
  include ActiveModel::Model

  attr_accessor :latitude, :longitude, :season, :plant, :station, :reporting_date, :phase
  validates :latitude, :longitude, presence: true,
                                   format: { with: /\A\d+(\.\d+)*\z/,
                                             message: "keine gültige Geolocation" }

  def deliver
    if valid?
      # deliver email
    end
  end

  def geolocation
    { latitude:  Float(latitude),
      longitude: Float(longitude) }
  end
end
