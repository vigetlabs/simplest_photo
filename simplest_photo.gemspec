$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "simplest_photo/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "simplest_photo"
  s.version     = SimplestPhoto::VERSION
  s.authors     = ["Chris Jones"]
  s.email       = ["chris.jones@viget.com"]
  s.homepage    = "http://github.com/vigetlabs/simplest_photo"
  s.summary     = ""
  s.description = ""
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.2.1"

  s.add_development_dependency "sqlite3"
end
