FactoryGirl.define do
  factory :mock_user, class: User do
    sequence(:email) { |n| "mockuser#{n}@gmail.com" }
    password 'testpassword'
    password_confirmation 'testpassword'
    first_name 'john'
    last_name 'doe'
    city 'new york'
    country 'united states'
    sequence(:username) { |n| "fakeuser_#{n}" }
    roles :user
  end

  factory :invalid_user, class: User do
    email 'a'
    password 'a'
    password_confirmation 'a'
    first_name 'a'
    last_name 'a'
    city 'a'
    country 'a'
    username 'a'
    roles :user
  end
end
