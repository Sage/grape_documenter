# -*- encoding: utf-8 -*-
require File.expand_path('../lib/grape_documenter/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Phil Lee", "Steven Anderson"]
  gem.email         = ["philip.lee@sage.com"]
  gem.description   = "This adds a task to Rails Applications to generate documentation for Grape APIs."
  gem.summary       = "This adds a task to Rails Applications to generate documentation for Grape APIs."
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "grape_documenter"
  gem.require_paths = ["lib"]
  gem.version       = GrapeDocumenter::VERSION

  gem.add_dependency 'grape', '0.2.1'
  gem.add_dependency 'RedCloth'
  gem.add_dependency 'activesupport'

  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'guard-rspec'
  gem.add_development_dependency 'pry'
end
