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
    get :index, params: { page: 2, format: "js" }, xhr: true

    assert_response :success
    assert_select "section", count: 0
    assert_select "#post_3", count: 1, text: "post 3"
    assert_select "#post_4", count: 1, text: "post 4"
    assert_select "#post_2", count: 0
  end

  test "get negative page" do
    get :index, params: { page: '-1' }
    assert_response :success
    assert_equal 1, @controller.current_page
  end

  test "get bogus page" do
    get :index, params: { page: 'bogus' }
    assert_response :success
    assert_equal 1, @controller.current_page
  end
end
