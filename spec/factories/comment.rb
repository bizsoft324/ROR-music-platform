FactoryGirl.define do
  factory :comment, class: Comment do
    association :user
    association :critique
    title 'This Is A Comment'
    subject 'This Is A Comment'
    body { Faker::Hipster.paragraph(10) }
  end
end
