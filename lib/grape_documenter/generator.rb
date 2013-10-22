require 'fileutils'
require 'active_support/inflector'

module GrapeDocumenter
  # Generator
  class Generator
    attr_reader :mounted_path

    def initialize(api_class, output_path, options = {})
      raise 'api_class must be specified' if api_class.nil?
      raise 'output_path must be specified' if output_path.nil?

      @output_path = output_path
      @api_class = api_class.constantize
      @format = options[:format] || 'html'
      @mounted_path = options[:mounted_path] || ''
    end

    def generate_namespace_docs
      docs = []

      @api_class.versions.each do |version|
        namespaces_for_version(version).each do |namespace|
          docs << NamespaceDoc.new(:version => version,
                                   :title => titleize(namespace),
                                   :root_path => namespace,
                                   :routes => routes_for_version_and_namespace(version, namespace),
                                   :resources => resources_for_version(version))
        end
      end

      docs
    end

    def output
      files = {}
      generate_namespace_docs.each do |doc|
        puts doc.title

        filename = File.join(@output_path, doc.version, "#{doc.root_path}.#{@format}")
        files[filename] = self.send("generate_#{@format}", doc)
      end

      Writer.new(files).write_to_files!
    end

    private

    def generate_textile(doc)
      Formatters::Textile.new(doc).format
    end

    def generate_html(doc)
      Formatters::Html.new(doc).format
    end

    def resources_for_version(version)
      resources = []
      namespaces_for_version(version).each do |resource|
        resources << { :name => titleize(resource), :path => resource }
      end
      resources
    end

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
      routes_for_version(version).select { |r| normalize_route_namespace(r) == namespace }.map{|r| RouteDoc.new(r, :mounted_path => @mounted_path)}
    end

    def titleize(string)
      string.split('/').last.titleize
    end
  end
end
