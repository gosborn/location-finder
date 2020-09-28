class CalculateLocationLatLngJob < ApplicationJob
  queue_as :default

  def perform(*args)
    location = Location.find(args)
    puts location
  end
end
