module GrapeDocumenter
  class NamespaceDoc
    attr_reader :title, :routes, :root_path, :version, :resources

    def initialize(options = {})
      @title = options[:title]
      @routes = options[:routes]
      @root_path = options[:root_path]
      @version = options[:version]
      @resources = options[:resources]
    end
  end
end
