class Location < ApplicationRecord
  has_many :visits
  has_many :users, through: :visits

  before_save :recalculate_geocode

  private

  def recalculate_geocode
    if latitude_changed? || longitude_changed? || latlng.nil?
      puts "doing stuff"
      self.latlng = "POINT (#{longitude} #{latitude})"
    end
  end
end
