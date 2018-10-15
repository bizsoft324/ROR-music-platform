FactoryGirl.define do
  factory :artist_type do
    sequence(:name) { |n| "#{Faker::Company.name}#{n}" }
  end
end
