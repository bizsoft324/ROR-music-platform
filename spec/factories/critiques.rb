FactoryGirl.define do
  factory :critique, class: Critique do
    association :track
  end
end
