require 'rails_helper'

describe "Notification" do
  let!(:user1) { create(:user) }
  let!(:user2) { create(:user) }
  
    before do
     sign_in user1
    end

  describe "Create Notification" do
    
    describe "create notification_follow", type: :system do
      
      it "create notification_follow successfully", js: true do 
        visit user_path(user2)
      end
    end
    
  end
end