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

  def calculate_status; end

  def recalculate_location; end
end
