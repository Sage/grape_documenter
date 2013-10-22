require 'grape_documenter'

module GrapeDocumenter
  class Railtie < Rails::Railtie
    rake_tasks do
      load 'tasks/generate.rake'
    end
  end
end
