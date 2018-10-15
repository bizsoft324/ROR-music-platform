FactoryGirl.define do
  factory :genre, class: Genre do
    name do
      [
        Faker::StarWars.species,
        Faker::StarWars.planet,
        Faker::StarWars.vehicle,
        Faker::Superhero.power
      ].sample
    end
  end
end
