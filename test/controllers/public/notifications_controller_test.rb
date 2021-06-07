require 'test_helper'

class Public::NotificationsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get public_notifications_index_url
    assert_response :success
  end

end
