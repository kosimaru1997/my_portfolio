# frozen_string_literal: true

require 'test_helper'

class Unlogin::PostsControllerTest < ActionDispatch::IntegrationTest
  test 'should get index' do
    get unlogin_posts_index_url
    assert_response :success
  end
end
