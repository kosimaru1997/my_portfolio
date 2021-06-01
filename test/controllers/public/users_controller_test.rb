require 'test_helper'

class Public::UsersControllerTest < ActionDispatch::IntegrationTest
  test "should get edit" do
    get public_users_edit_url
    assert_response :success
  end

  test "should get destroy" do
    get public_users_destroy_url
    assert_response :success
  end

end
