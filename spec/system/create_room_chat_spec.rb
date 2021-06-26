require 'rails_helper'

describe "Create Rooms and Chats" do
  let!(:user1) { create(:user) }
  let!(:user2) { create(:user) }

  before do
    sign_in user1
  end

  describe "Create Room", type: :system do
    it "create room successfully" do
      visit user_path(user2)
      expect {
       find(".create_room").click
      }.to change(Room, :count).by(1).and change {UserRoom.count}.by(2)
      expect(page).to have_content user2.name
    end
  end

  describe "Create Chats", type: :system do
    let!(:room) { create(:room) }
    let!(:user_room1) { UserRoom.create(user_id: user1.id, room_id: room.id) }
    let!(:user_room2) { UserRoom.create(user_id: user2.id, room_id: room.id) }
    let!(:chat) {Chat.create(user_id: user2.id, room_id: room.id, message: Faker::Lorem.characters(number: 20)) }

    before do
      visit room_path(room)
    end

    it "create chats after failure", js: true do
      expect(current_path).to eq room_path(room)
      expect(page).to have_content chat.message
      expect {
        fill_in "chat[message]", with: ""
        click_button "送信"
        sleep 0.5
      }.to change(Chat, :count).by(0)
      expect {
        fill_in "chat[message]", with: "テストチャット"
        click_button "送信"
      }.to change(Chat, :count).by(1)
      expect(page).to have_content "テストチャット"
    end
  end

end