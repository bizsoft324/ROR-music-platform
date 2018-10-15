FactoryGirl.define do
  factory :track do
    association :user
    # association :artist_type
    title { Faker::Book.title }
    # audio { File.open("#{Rails.root}/spec/fixtures/art_of_cool.mp3") }
    image { File.open("#{Rails.root}/spec/fixtures/images/artofcool.jpg") }
    description { Faker::Lorem.paragraph }
  end
end
