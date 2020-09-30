class Visit < ApplicationRecord
  belongs_to :user
  belongs_to :location

  enum status: {
    confirmed: 'confirmed',
    flagged: 'flagged',
    pending: 'pending',
    expired: 'expired'
  }

  after_initialize do |visit|
    visit.status ||= 'pending'
  end

  before_validation :recalculate_geocode
  before_save :calculate_status

  after_save :recalculate_location

  METERS_IN_HALF_MILE = 402.336

  private

  def recalculate_geocode
    PointGeocoder.new(self, :latitude, :longitude, :latlng).geocode_point
  end

  def calculate_status
    return unless can_calculate_status

    meters_away_from_location = location.latlng.distance(latlng)
    self.status = meters_away_from_location.between?(0, METERS_IN_HALF_MILE) ? 'confirmed' : 'flagged'
  end

  def can_calculate_status
    latlng.present? && location&.latlng.present?
  end

  def recalculate_location
    return unless (location.visits.count % 3).zero?

    CalculateLocationLatLngJob.perform_later location.id
  end
end
