require 'test_helper'
require 'capybara/rails'

class InfinitePageIntegrationTest < ActionDispatch::IntegrationTest
  include Capybara::DSL

  setup do
    Capybara.server_port = '54163'
    Capybara.current_driver = :selenium
  end

  test "more pages are loaded" do
    create_posts(4)
    visit "/posts"

    assert page.has_content?("post 1"), page.body
    assert page.has_content?("post 2"), page.body
  end
end