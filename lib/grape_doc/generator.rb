require 'fileutils'
require 'RedCloth'

module GrapeDoc
  class Generator
    def initialize(api_class, output_path)
      raise 'api_class must be specified' if api_class.nil?
      raise 'output_path must be specified' if output_path.nil?

      @output_path = output_path
      @api_class = api_class.constantize
    end

    def generate_namespace_docs
      docs = []

      @api_class.versions.each do |version|
        namespaces_for_version(version).each do |namespace|
          doc = NamespaceDoc.new
          doc.title = titleize(namespace)
          doc.root_path = namespace
          doc.routes = routes_for_version_and_namespace(version, namespace)
          doc.version = version
          docs << doc
        end
      end

      docs
    end

    def output
      files = {}
      generate_namespace_docs.each do |doc|
        puts doc.title

        filename = File.join(@output_path, doc.version, "#{doc.root_path}.textile")
        files[filename] = generate_textile(doc)
      end

      Writer.new(files).write_to_files!
    end

    def generate_textile(doc)
      Formatters::Textile.new(doc, self).format
    end

    #TODO: Refactor this into the Textile formatter class.
    def namespace_links_for_version(version, namespace)
      slashes = '../' * (namespace.count('/')-1)
      resources_string = ""
      namespaces_for_version(version).each do |resource|
        resources_string << "* \"#{titleize(resource)}\":#{slashes}#{resource.sub('/', '')}.html\n"
      end
      resources_string
    end

    private

    def namespaces_for_version(version)
      return instance_variable_get("@#{version}_namespaces") if instance_variable_get("@#{version}_namespaces")

      instance_variable_set("@#{version}_namespaces", routes_for_version(version).map { |r| normalize_route_namespace(r) }.uniq)
    end

    def normalize_route_namespace(route)
      n = route.route_namespace
      route.route_params.each do |p,_|
        n.gsub!(":#{p.gsub('/', '')}", '')
      end
      n.gsub(/\/+/, '/')
    end

    def routes_for_version(version)
      return instance_variable_get("@#{version}_routes") if instance_variable_get("@#{version}_routes")

      instance_variable_set("@#{version}_routes", @api_class.routes.select { |r| r.route_version == version })
    end

    def routes_for_version_and_namespace(version, namespace)
      routes_for_version(version).select { |r| normalize_route_namespace(r) == namespace }
    end

    def titleize(string)
      string.split('/').last.titleize
    end
  end
end
