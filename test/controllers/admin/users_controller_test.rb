# frozen_string_literal: true

require 'test_helper'

class Admin::UsersControllerTest < ActionDispatch::IntegrationTest
  test 'should get top' do
    get admin_users_top_url
    assert_response :success
  end
end
