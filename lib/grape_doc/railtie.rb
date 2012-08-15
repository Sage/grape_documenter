require 'grape_doc'

module GrapeDoc
  class Railtie < ::Rails::Railtie
    rake_tasks do
      load 'tasks/generate.rake'
    end
  end
end
