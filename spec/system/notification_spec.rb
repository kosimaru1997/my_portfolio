require 'rails_helper'

describe "Notification" do
  let!(:user1) { create(:user) }
  let!(:user2) { create(:user) }
  let!(:user3) { create(:user) }
  let!(:post1) { user1.posts.create(content: Faker::Lorem.characters(number: 20)) }
  let!(:post2) { user2.posts.create(content: Faker::Lorem.characters(number: 20)) }

    before do
      sign_in user1
    end

  describe "Show Notification" do

    describe "show notification_follow", type: :system do
      let!(:notification_follow) { Notification.create(visitor_id: user2.id, visited_id: user1.id, action: "follow") }

      it "show notification_follow successfully", js: true do
        visit root_path
        within(".notice") do
          expect(page).to have_css(".n-circle")
          find(".fa-bell").click
          sleep 0.5
          expect(page).to have_no_css(".n-circle")
        end
        
        expect(page).to have_content "フォローしました"
      end
    end

    describe "show notification_favorite", type: :system do
      let!(:notification_favorite) { Notification.create(visitor_id: user2.id, visited_id: user1.id, post_id: post1.id, action: "favorite") }

      it "show notification_favorite successfully", js: true do
        visit root_path
        within(".notice") do
          expect(page).to have_css(".n-circle")
          find(".fa-bell").click
          sleep 0.5
          expect(page).to have_no_css(".n-circle")
        end
        expect(page).to have_content "いいねしました"
      end
    end

    describe "show notification_repost", type: :system do
      let!(:notification_repost) { Notification.create(visitor_id: user2.id, visited_id: user1.id, post_id: post1.id, action: "repost") }

      it "show notification_repost successfully", js: true do
        visit root_path
        within(".notice") do
          expect(page).to have_css(".n-circle")
          find(".fa-bell").click
          sleep 0.5
          expect(page).to have_no_css(".n-circle")
        end
        expect(page).to have_content "リポストしました"
      end
    end

     describe "show notification_comment", type: :system do
      let!(:post_comment1) {user1.post_comments.create(post_id: post2.id, comment: Faker::Lorem.characters(number: 20))}
      let!(:post_comment2) {user2.post_comments.create(post_id: post1.id, comment: Faker::Lorem.characters(number: 20))}
      let!(:post_comment3) {user3.post_comments.create(post_id: post2.id, comment: Faker::Lorem.characters(number: 20))}
      let!(:notification_comment1) { Notification.create(visitor_id: user2.id, visited_id: user1.id,
                                                        post_id: post1.id, post_comment_id: post_comment2.id, action: "comment") }
      let!(:notification_comment2) { Notification.create(visitor_id: user3.id, visited_id: user1.id,
                                                        post_id: post2.id, post_comment_id: post_comment3.id, action: "comment") }

      it "show notification_comment successfully", js: true do
        visit root_path
        within(".notice") do
          expect(page).to have_css(".n-circle")
          find(".fa-bell").click
          sleep 0.5
          expect(page).to have_no_css(".n-circle")
        end
        form_inlines = all(".form-inline")
        form_inline_0 = form_inlines[0]
        form_inline_1 = form_inlines[1]
        expect(form_inline_0).to have_content user2.name
        expect(form_inline_0).to have_content "あなたの投稿"
        expect(form_inline_1).to have_content user3.name
        expect(form_inline_1).to have_content "#{user2.name}さんの投稿"
      end
    end

  end
end