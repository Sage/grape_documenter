require 'simplecov'
SimpleCov.start do
  add_filter "spec/"
end
require 'grape_documenter'
require 'support/test_api'
