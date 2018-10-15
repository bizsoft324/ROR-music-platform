FactoryGirl.define do
  sequence :email do |n|
    "user_#{n}@example.com"
  end

  factory :user do
    email
    username { Faker::Internet.user_name(4) }
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    password '12345678'
    city { Faker::Address.city }
    country 'US'

    before(:create) { User.skip_callback(:save, :after, :confirm_email) }

    after(:create) { User.set_callback(:save, :after, :confirm_email) }

    trait :with_confirm_email do
      before(:create) { User.set_callback(:save, :after, :confirm_email) }
    end
  end
end
