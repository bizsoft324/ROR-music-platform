FactoryGirl.define do
  factory :identity do
    access_token { Faker::Internet.password }
    avatar_url { Faker::Company.logo }
  end

  factory :soundcloud_identity, parent: :identity do
    provider 'soundcloud'
  end
end
