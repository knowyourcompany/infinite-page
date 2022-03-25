Gem::Specification.new do |s|
  s.name     = "infinite_page"
  s.version  = "0.6.6"
  s.summary  = "Infinite scrolling and pagination for Rails 5+"
  s.authors  = ["Javan Makhmali"]
  s.email    = ["javan@37signals.com"]
  s.homepage = "https://github.com/37signals/infinite_page"

  s.files = Dir["lib/**/*"] + ["LICENSE", "Rakefile", "README.md"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails"
  s.add_dependency "sprockets"
  s.add_dependency "coffee-script"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "capybara"
  s.add_development_dependency "capybara-webkit"
  s.add_development_dependency "bundle"
  s.add_development_dependency "puma"
end
