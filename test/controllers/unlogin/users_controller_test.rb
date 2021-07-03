# frozen_string_literal: true

require 'test_helper'

class Unlogin::UsersControllerTest < ActionDispatch::IntegrationTest
  test 'should get index' do
    get unlogin_users_index_url
    assert_response :success
  end

  test 'should get show' do
    get unlogin_users_show_url
    assert_response :success
  end
end
