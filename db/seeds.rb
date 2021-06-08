User.create!(name:  "テストユーザー",
             email: "test@test.com",
             password:              "aaaaaa",
             password_confirmation: "aaaaaa")

# 追加のユーザーをまとめて生成する
99.times do |n|
  name  = Faker::Name.name
  email = "example#{n+1}@gmail.com"
  password = "password"
  User.create!(name:  name,
               email: email,
               password:              password,
               password_confirmation: password)
  Relationship.create!(follower_id: 1, followed_id: n+1)
  
end

users = User.order(:created_at).take(6)
50.times do
  content = Faker::Lorem.sentence(word_count: 10)
  users.each { |user| user.posts.create!(content: content) }
end

50.times do |n|
  Relationship.create!(follower_id: 1, followed_id: n+1)
end

50.times do |n|
  Relationship.create!(follower_id: n+1, followed_id: 1)
end