class Visit < ApplicationRecord
  belongs_to :user
  belongs_to :location

  before_validation :recalculate_geocode
  before_save :calculate_status

  after_save :recalculate_location

  enum status: {
    confirmed: 'confirmed',
    flagged: 'flagged',
    pending: 'pending',
    expired: 'expired'
  }

  def recalculate_location
    return unless (location.visits.count % 3).zero?
    CalculateLocationLatLngJob.perform_later location.id
  end

  private

  def recalculate_geocode
    PointGeocoder.new(self, :latitude, :longitude, :latlng).geocode_point
  end

  # will use geocoding gem to determine how far away visit is to defined location
  # and set status to confirmed if close otherwise flagged
  def calculate_status; end
end
