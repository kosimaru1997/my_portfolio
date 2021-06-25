require 'rails_helper'

describe "Users sign_up log_in log_out test" do

  describe "Users sign up", type: :system do
    before do
      visit root_path
    end

    it "correct link before sign_up" do
      expect(page).to have_link "", href: "/"
      expect(page).to have_link "", href: "/unlogin/posts"
      expect(page).to have_link "", href: "/unlogin/users"
      expect(page).to have_link "お問い合わせ", href: "/inquiry"
    end

    it "user successfully sign_up" do
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

    it "user failure sign_up", js: true do
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

  describe "Users log_in" do
    let(:user) { create(:user) }

    before do
      visit root_path
    end

    it "user successfully log_in and log_out" do
      within("#login") do
        fill_in "user[email]", with: user.email
        fill_in "user[password]", with: user.password
        click_button "Log in"
      end
      expect(current_path).to eq "/"
      expect(page).to have_link "", href: "/"
      expect(page).to have_link "", href: "/posts"
      expect(page).to have_link "", href: "/notifications"
      expect(page).to have_link "", href: "/rooms"
      expect(page).to have_link "マイページ", href: "/users/#{user.id}"
      expect(page).to have_link "ユーザー一覧", href: "/users"
      expect(page).to have_link "ログアウト", href: "/users/sign_out"
      expect(page).to have_link "お問い合わせ", href: "/inquiry"
      click_link "ログアウト"
      expect(page).to have_link "", href: "/unlogin/posts"
    end

    it "user failure log in" do
      within("#login") do
        fill_in "user[email]", with: ""
        fill_in "user[password]", with: ""
        click_button "Log in"
      end
        expect(current_path).to eq "/"
        expect(page).to have_no_link "マイページ", href: "/users/#{user.id}"
    end
  end

end