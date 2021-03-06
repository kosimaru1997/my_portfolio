Admin.create!(email: "admin@admin.com",
              password:              "password",
              password_confirmation: "password")

User.create!(name:  "テストユーザー",
             email: "test@test.com",
             password:              "aaaaaa",
             password_confirmation: "aaaaaa")
             
User.create(name: "キータ", email:"sample@sample.com", password:"aaaaaa")
User.create(name: "Zenn", email:"sample2@sample.com", password:"aaaaaa")
User.create(name: "railsエンジニア", email:"sample3@sample.com", password:"aaaaaa")

# 追加のユーザーをまとめて生成する
99.times do |n|
  name  = Faker::Name.name
  email = "example#{n+1}@gmail.com"
  password = "password"
  User.create!(name:  name,
               email: email,
               password:              password,
               password_confirmation: password)
end

users = User.order(:created_at).take(6)
50.times do
  content = Faker::Lorem.sentence(word_count: 10)
  users.each { |user| user.posts.create!(content: content) }
end

users = User.all
user  = users.first
following = users[2..50]
followers = users[3..40]
following.each { |followed| user.follow(followed) }
followers.each { |follower| follower.follow(user) }