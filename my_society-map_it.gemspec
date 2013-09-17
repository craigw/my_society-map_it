# -*- encoding: utf-8 -*-
require File.expand_path('../lib/my_society/map_it/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Craig R Webster"]
  gem.email         = ["craig@barkingiguana.com"]
  gem.description   = %q{API for MySociety's MapIt service}
  gem.summary       = %q{API for MySociety's MapIt service}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "my_society-map_it"
  gem.require_paths = ["lib"]
  gem.version       = MySociety::MapIt::VERSION

  gem.add_development_dependency "rspec"
  gem.add_development_dependency "simplecov-rcov"
  gem.add_development_dependency "fakeweb"
  gem.add_development_dependency "vcr"
end
