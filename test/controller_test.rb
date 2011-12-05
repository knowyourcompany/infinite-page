require 'test_helper'

class PostsControllerTest < ActionController::TestCase
  setup do
    create_posts(4)
  end

  test "get page one" do
    get :index

    assert_response :success
    assert_select "section", count: 1
    assert_select "#post_1", count: 1, text: "post 1"
    assert_select "#post_2", count: 1, text: "post 2"
    assert_select "#post_3", count: 0
  end

  test "xhr get page two" do
    xhr :get, :index, page: 2, format: "js"

    assert_response :success
    assert_select "section", count: 0
    assert_select "#post_3", count: 1, text: "post 3"
    assert_select "#post_4", count: 1, text: "post 4"
    assert_select "#post_2", count: 0
  end
end