require 'rails_helper'

describe "Relationship" do
  let!(:user1) { create(:user) }
  let!(:user2) { create(:user) }

    before do
     sign_in user1
    end

  describe "Create Relationship" do

    describe "create relationships", type: :system do

      it "create relationships successfully", js: true do
        visit user_path(user2)
        expect {
        find(".follow").click
        sleep 0.5
        }.to change(Relationship, :count).by(1)
      end

      it "error_handling on creating relationships with double click", js: true do
        visit user_path(user2)
        expect {
        find(".follow").double_click
        sleep 0.5
        }.to change(Relationship, :count).by(1)
      end
    end

    describe "destroy relationships", type: :system do
      let!(:relationships) { Relationship.create(follower_id: user1.id, followed_id: user2.id) }

      it "create relationships successfully", js: true do
        visit user_path(user2)
        expect {
        find(".unfollow").click
        sleep 0.5
        }.to change(Relationship, :count).by(-1)
      end

      it "error_handling on destroy relationships with double click", js: true do
        visit user_path(user2)
        expect {
        find(".unfollow").double_click
        sleep 0.5
        }.to change(Relationship, :count).by(-1)
      end
    end

  end
end