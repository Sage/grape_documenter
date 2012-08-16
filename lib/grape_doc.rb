require "grape_doc/version"

module GrapeDoc
  require 'grape_doc/generator'
  require 'grape_doc/writer'
  require 'grape_doc/namespace_doc'
  require 'grape_doc/route_doc'
  require 'grape_doc/formatters/textile'
  require 'grape_doc/formatters/html'
  require 'grape_doc/railtie' if defined?(Rails)
end
