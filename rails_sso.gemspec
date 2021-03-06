$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "rails_sso/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "rails_sso"
  s.version     = RailsSso::VERSION
  s.authors     = ["Jan Dudulski"]
  s.email       = ["jan@dudulski.pl"]
  s.homepage    = "https://github.com/monterail/rails_sso"
  s.summary     = "SSO Rails Engine"
  s.description = "Single Sign On solution via OAuth2 for Ruby on Rails."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.1"
  s.add_dependency "faraday-http-cache", "~> 1.0"
  s.add_dependency "omniauth-oauth2", "~> 1.2", "< 1.4"
  s.add_dependency "warden", "~> 1.2"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "anima"
  s.add_development_dependency "mocha"
  s.add_development_dependency "pry"
end
