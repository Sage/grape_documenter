require 'simplecov'
SimpleCov.start do
  add_filter "spec/"
end
require 'grape_doc'
require 'support/test_api'
