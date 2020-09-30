class Visit < ApplicationRecord
  belongs_to :user
  belongs_to :location

  enum status: {
    confirmed: 'confirmed',
    flagged: 'flagged',
    pending: 'pending',
    expired: 'expired'
  }

  before_validation :recalculate_geocode
  before_save :calculate_status

  after_save :recalculate_location

  METERS_IN_HALF_MILE = 402.336

  def recalculate_location
    return unless (location.visits.count % 3).zero?

    CalculateLocationLatLngJob.perform_later location.id
  end

  private

  def recalculate_geocode
    PointGeocoder.new(self, :latitude, :longitude, :latlng).geocode_point
  end

  def calculate_status
    status = self.status || 'pending'
    if latlng.present? && location.latlng.present?
      if location.latlng.distance(latlng).between?(0, METERS_IN_HALF_MILE)
        status = 'confirmed'
      end
      if location.latlng.distance(latlng) > METERS_IN_HALF_MILE
        status = 'flagged'
      end
    end
    self.status = status
  end
end
