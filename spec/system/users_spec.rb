require 'rails_helper'

describe "Users before_login test" do

  describe "Users sign up", type: :system do
    before do
      visit root_path
    end

    it "user successfully sign up" do
      within("#sign-up") do
        expect {
          fill_in "user[name]", with: "テスト"
          fill_in "user[email]", with: "test@example.com"
          fill_in "user[password]", with: "test123"
          fill_in "user[password_confirmation]", with: "test123"
          click_button "Sign up"
        }.to change(User, :count).by(1)
      end

      expect(current_path).to eq "/"
      expect(page).to have_content "テスト"
    end

    it "user failure sign up", js: true do
        within("#sign-up") do
        expect {
          fill_in "user[name]", with: "テスト"
          fill_in "user[email]", with: "test@example.com"
          fill_in "user[password]", with: "test123"
          fill_in "user[password_confirmation]", with: "test000"
          click_button "Sign up"
        }.to change(User, :count).by(0)
      end
      expect(current_path).to eq "/"
      expect(page).to have_css(".errors")
      expect(page).to have_css(".field_with_errors")
    end
  end

  describe "Users log in" do
    let(:user) { create(:user) }

    before do
      visit root_path
    end

    it "user successfully log in" do
      within("#login") do
        fill_in "user[email]", with: user.email
        fill_in "user[password]", with: user.password
        click_button "Log in"
      end
      expect(current_path).to eq "/"
      expect(page).to have_content user.name
    end

    it "user failure log in" do
      within("#login") do
        fill_in "user[email]", with: ""
        fill_in "user[password]", with: ""
        click_button "Log in"
      end
        expect(current_path).to eq "/"
        expect(page).to have_no_content user.name
    end
  end

end