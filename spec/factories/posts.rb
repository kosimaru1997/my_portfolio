FactoryBot.define do
  factory :post do
    user_id {1}
    content { Faker::Lorem.characters(number: 10) }
  end
end