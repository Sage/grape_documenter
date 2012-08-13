require "grape_doc/version"

module GrapeDoc
  require 'grape_doc/generator'
  require 'grape_doc/railtie' if defined?(Rails)
end
