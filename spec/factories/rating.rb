FactoryGirl.define do
  factory :rating, class: Rating do
    association :user
  end
end
