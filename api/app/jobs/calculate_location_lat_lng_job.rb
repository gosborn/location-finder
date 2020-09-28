class CalculateLocationLatLngJob < ApplicationJob
  queue_as :default

  def perform(*args)
    puts "Testing!"
  end
end
