FactoryBot.define do
  factory :item do
    association :merchant
    name { Faker::Commerce.product_name }
    description {Faker::Lorem.sentence}
    unit_price { Faker::Number.within(range: 1..1000) }
  end
end
