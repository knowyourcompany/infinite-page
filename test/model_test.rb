require 'test_helper'

class InfinitePageScopeInModelTest < ActiveSupport::TestCase
  test "page scope returns correct records" do
    create_posts(4)

    assert_equal ["post 1", "post 2"], Post.page(1, 2).map(&:content)
    assert_equal ["post 3", "post 4"], Post.page(2, 2).map(&:content)
  end
end
