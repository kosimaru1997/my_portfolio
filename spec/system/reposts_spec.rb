require 'rails_helper'

describe "Repost" do
  let!(:user1) { create(:user) }
  let!(:user2) { create(:user) }
  let!(:post) { user2.posts.create(content: Faker::Lorem.characters(number: 30)) }

    before do
     sign_in user1
    end

  describe "Create or Destroy Repost" do

    describe "create reposts in post_show", type: :system do

      it "create favorites and notification successfully", js: true do
        visit post_path(post)
        within(".reposts_link") do
          expect(page).to have_content 0
          expect(page).to have_no_content 1
          expect {
          find(".fa-retweet").click
          sleep 0.5
          }.to change(Repost, :count).by(1).and change {Notification.count}.by(1)
          expect(page).to have_content 1
          expect(page).to have_no_content 0
        end
      end

       it "in posts_index create reposts with double click", js: true do
        visit posts_path
        expect {
        find(".fa-retweet").double_click
        sleep 0.5
        }.to change(Repost, :count).by(1).and change {Notification.count}.by(1)
      end
    end

    describe "destroy Repost", type: :system do
      let!(:repost) { user1.reposts.create(post_id: post.id)}

      it "destroy reposts successfully post_show", js: true do
        visit post_path(post)
        expect {
        find(".fa-retweet").click
        sleep 0.5
        }.to change(Repost, :count).by(-1)
      end

       it "in posts_index destroy reposts with double click", js: true do
        visit posts_path
        expect {
        find(".fa-retweet").double_click
        sleep 0.5
        }.to change(Repost, :count).by(-1)
      end
    end

  end
end