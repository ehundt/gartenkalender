class Season
  include ActiveModel::Model

  attr_accessor :latitude, :longitude, :address, :season, :plant, :station,
                :reporting_date, :phase
  validates :latitude, :longitude, presence: true,
                                   format: { with: /\A\d+(\.\d+)*\z/,
                                             message: "keine gültige Geolocation" }
  validate :only_germany

  def deliver
    if valid?
      # deliver email
    end
  end

  def geolocation
    { latitude:  Float(latitude),
      longitude: Float(longitude) }
  end

  def only_germany
    if !address.empty? && !/Germany/.match(address)
      errors.add(:only_germany, "Keine Wetterdaten außerhalb Deutschlands")
    end
  end
end
