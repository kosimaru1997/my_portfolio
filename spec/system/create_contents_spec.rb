require 'rails_helper'

describe "Create Post PostComent replies" do
  let!(:user) { create(:user) }

  describe "create posts", type: :system do

    before do
      sign_in user
      visit root_path
    end

    it "create posts successfully and destroy post", js: true do
      expect {
        fill_in "post[content]", with: "テストポスト"
        click_button "Post"
        sleep 0.5
      }.to change(Post, :count).by(1)
      expect(page).to have_content "テストポスト"
      expect {
        click_link "削除"
        page.driver.browser.switch_to.alert.accept
        sleep 0.5
      }.to change(Post, :count).by(-1)
    end

    it "create posts after failure", js: true do
      expect {
      fill_in "post[content]", with: Faker::Lorem.characters(number: 143)
      click_button "Post"
      }.to change(Post, :count).by(0)
      expect(page).to have_content "１文字以上１４０文字以下で投稿してください"
      expect {
      fill_in "post[content]", with: Faker::Lorem.characters(number: 140)
      click_button "Post"
      }.to change(Post, :count).by(1)
    end
  end

  describe "create post_comments replies", type: :system do
    let!(:post) { user.posts.create(content: "テスト") }
    let!(:user2) { create(:user) }

    describe "create post_comments" do

    before do
      sign_in user2
      visit post_path(post.id)
    end

      it "create post_comments successfully and destroy", js: true do
        expect {
          fill_in "post_comment[comment]", with: "テストコメント１"
          click_button "コメント"
          sleep 0.5
        }.to change(PostComment, :count).by(1)
        expect(page).to have_content "テストコメント１"
        expect {
          find(".delete_comment").click
          page.driver.browser.switch_to.alert.accept
          sleep 0.5
        }.to change(PostComment, :count).by(-1)
        expect(page).to have_no_content "テストコメント１"
      end

      it "create posts after failure", js: true do
        expect {
        fill_in "post_comment[comment]", with: Faker::Lorem.characters(number: 143)
        click_button "コメント"
        # sleep 0.5
        }.to change(PostComment, :count).by(0)
        expect(page).to have_content "１文字以上１４０文字以下で投稿してください"
        expect {
        fill_in "post_comment[comment]", with: Faker::Lorem.characters(number: 140)
        click_button "コメント"
        # sleep 0.5
        }.to change(PostComment, :count).by(1)
      end

    end

    describe "create replies" do
      let!(:user3) { create(:user) }
      let!(:post_comment) { user2.post_comments.create(post_id: post.id, comment: "テストコメント")}

      before do
        sign_in user3
        visit post_path(post.id)
      end

      it "create replay successfully and destroy", js: true do
        expect(current_path).to eq "/posts/#{post.id}"
        expect(page).to have_content "テストコメント"
        find(".replies_path").click
        expect(page).to have_content "リプライはありません"
        within("#post_comment#{post_comment.id}") do
        expect {
          fill_in "post_comment[comment]", with: "テストリプライ"
          click_button "リプライ"
          sleep 0.5
        }.to change(PostComment, :count).by(1)
        expect(page).to have_content "テストリプライ"
        expect {
          find('.delete_reply').click
          page.driver.browser.switch_to.alert.accept
          sleep 0.5
        }.to change(PostComment, :count).by(-1)
        expect(page).to have_no_content "テストリプライ"
        end
      end

      it "create replay after failure", js: true do
        find(".replies_path").click
        within("#post_comment#{post_comment.id}") do
          expect {
            fill_in "post_comment[comment]", with: Faker::Lorem.characters(number: 141)
            click_button "リプライ"
            # sleep 0.5
          }.to change(PostComment, :count).by(0)
          expect {
            fill_in "post_comment[comment]", with: Faker::Lorem.characters(number: 140)
            click_button "リプライ"
            # sleep 0.5
          }.to change(PostComment, :count).by(1)
        end
      end
    end

  end
end