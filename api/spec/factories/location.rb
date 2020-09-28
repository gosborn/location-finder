FactoryBot.define do
  factory :location do
    sequence(:name) { |i| "Location #{i}" }
    description { 'A nice place' }
    latitude { 99.999 }
    longitude { 100.0000 }
  end
end
