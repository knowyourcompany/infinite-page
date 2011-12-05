require 'test_helper'
require 'capybara/rails'

class InfinitePageIntegrationTest < ActionDispatch::IntegrationTest
  include Capybara::DSL
  self.use_transactional_fixtures = false

  setup do
    Capybara.server_port = '54163'
    Capybara.current_driver = :selenium
  end

  test "more posts are asynchronously loaded as you scroll down the page" do
    create_posts(6)
    visit "/posts"

    assert page.has_content?("post 1")
    assert page.has_content?("post 2")

    click_link("scroll to bottom")

    assert page.has_content?("post 3")
    assert page.has_content?("post 4")

    click_link("scroll to bottom")

    assert page.has_content?("post 5")
    assert page.has_content?("post 6")
  end
end
