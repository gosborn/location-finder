FactoryBot.define do
  factory :user do
    sequence(:email) { |i| "test#{i}@example.com" }
    password { 'password567' }
  end
end
