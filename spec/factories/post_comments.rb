FactoryBot.define do
  factory :post_comment do
    user_id
    post_id
    comment
  end
end