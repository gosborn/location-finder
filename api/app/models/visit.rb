class Visit < ApplicationRecord
  belongs_to :user
  belongs_to :location

  before_save :calculate_status
  after_save :recalculate_location

  enum status: {
    confirmed: 'confirmed',
    flagged: 'flagged',
    pending: 'pending',
    expired: 'expired'
  }

  # will use geocoding gem to determine how far away visit is to defined location
  # and set status to confirmed if close otherwise flagged
  def calculate_status; end

  def recalculate_location
    # will eventually use lat/lng of visits to determine if location has been moved
    if location.visits.count % 3 == 0
      CalculateLocationLatLngJob.perform_later location.id
    end
  end
end
