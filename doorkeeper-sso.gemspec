$:.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "doorkeeper/sso/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
  spec.name        = "doorkeeper-sso"
  spec.version     = Doorkeeper::SSO::VERSION
  spec.authors     = ["xiaohui"]
  spec.email       = ["xiaohui@tanmer.com"]
  spec.homepage    = "https://github.com/tanmer/doorkeeper-sso"
  spec.summary     = "SSO/SLO plugin for Doorkeeper"
  spec.description = "Doorkeeper acts as real single-sign-on(SSO) and single-logout(SLO)"
  spec.license     = "MIT"

  spec.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  spec.add_dependency 'doorkeeper', '~> 5.4.0'

  spec.add_development_dependency 'guard-rspec', '~> 4.7', '>= 4.7.3'
  spec.add_development_dependency 'rails', '~> 5.2', '>= 5.2.3'
  spec.add_development_dependency 'rspec-rails', '~> 3.8', '>= 3.8.2'
  spec.add_development_dependency 'shoulda-matchers', '~> 4.1', '>= 4.1.2'
  spec.add_development_dependency 'simplecov', '~> 0.17.0'
  spec.add_development_dependency 'sqlite3', '~> 1.4', '>= 1.4.1'
end
