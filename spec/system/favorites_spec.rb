require 'rails_helper'

describe "Relationship" do
  let!(:user1) { create(:user) }
  let!(:user2) { create(:user) }
  let!(:post) { user2.posts.create(content: Faker::Lorem.characters(number: 30)) }

    before do
     sign_in user1
    end

  describe "Create or Destroy Favorete" do

    describe "create favorites and notification in post_show", type: :system do

      it "create favorites successfully", js: true do
        visit post_path(post)
        within(".favorites_link") do
          expect(page).to have_content 0
          expect(page).to have_no_content 1
          expect {
          find(".fa-heart").click
          sleep 0.5
          }.to change(Favorite, :count).by(1).and change {Notification.count}.by(1)
          expect(page).to have_content 1
          expect(page).to have_no_content 0
        end
      end

       it "in posts_index create favoretes with double click", js: true do
        visit posts_path
        expect {
        find(".fa-heart").double_click
        sleep 0.5
        }.to change(Favorite, :count).by(1).and change {Notification.count}.by(1)
      end
    end

    describe "Destroy Favorite", type: :system do
      let!(:favorite) { user1.favorites.create(post_id: post.id)}

      it "destroy favorites successfully post_show", js: true do
        visit post_path(post)
        expect {
        find(".fa-heart").click
        sleep 0.5
        }.to change(Favorite, :count).by(-1)
      end

       it "in posts_index destroy favoretes with double click", js: true do
        visit posts_path
        expect {
        find(".fa-heart").double_click
        sleep 0.5
        }.to change(Favorite, :count).by(-1)
      end
    end

  end
end