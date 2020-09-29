class Location < ApplicationRecord
  has_many :visits
  has_many :users, through: :visits

  before_save :recalculate_geocode

  private

  def recalculate_geocode
    PointGeocoder.new(self, :latitude, :longitude, :latlng).geocode_point
  end
end
