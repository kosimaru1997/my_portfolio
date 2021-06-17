require 'test_helper'

class InquiryControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get inquiry_index_url
    assert_response :success
  end

  test "should get confirm" do
    get inquiry_confirm_url
    assert_response :success
  end

  test "should get thanks" do
    get inquiry_thanks_url
    assert_response :success
  end

end
