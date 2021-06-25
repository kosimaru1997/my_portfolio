FactoryBot.define do
  factory :post_comment do
    user_id {1}
    post_id {1}
    comment { Faker::Lorem.characters(number: 10) }
  end
end