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
        click_link user_relationships
      end
    end
    
  end
end