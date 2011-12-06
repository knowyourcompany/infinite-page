Gem::Specification.new do |s|
  s.name     = "infinite_page"
  s.version  = "0.5.0"
  s.summary  = "Infinite scrolling and pagination for Rails 3.1+"
  s.authors  = ["Javan Makhmali"]
  s.email    = ["javan@37signals.com"]
  s.homepage = "https://github.com/37signals/infinite_page"

  s.files = Dir["lib/**/*"] + ["LICENSE", "Rakefile", "README.md"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", ">= 3.1.0"
  s.add_dependency "sprockets"
  s.add_dependency "coffee-script"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "capybara"
end