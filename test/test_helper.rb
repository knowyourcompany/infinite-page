# Configure Rails Environment
ENV["RAILS_ENV"] = "test"

require File.expand_path("../dummy/config/environment.rb",  __FILE__)
require "rails/test_help"

Rails.backtrace_cleaner.remove_silencers!

class ActiveSupport::TestCase
  def create_posts(count)
    count.times { |i| Post.create! content: "post #{i + 1}" }
  end
end