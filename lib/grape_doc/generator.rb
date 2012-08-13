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

    def output
      @api_class.versions.each do |version|
        puts "Generating Version: #{version}..."

        ensure_version_path_present(version)

        namespaces_for_version(version).each do |namespace|
          puts "Namespace: #{namespace}..."
          FileUtils.mkdir_p(File.join(@output_path, version, *namespace.split('/')[1..-2]))

          filename = File.join(@output_path, version, "#{namespace}.textile")

          File.open(filename, 'w') do |f|
            f.write(namespace_links_for_version(version, namespace))

            f.write("\n\n")
            f.write "h1. #{titleize(namespace)}"

            routes_for_version_and_namespace(version, namespace).each do |route|
              f.write("\n\n")
              f.write "h2. #{route.route_method}: #{route.route_path.gsub(':version', version)}"
              f.write("\n\n")

              if route.route_description.present?
                f.write("h3. Description")
                f.write("\n\n")
                f.write route.route_description
                f.write("\n\n")
              end

              if route.route_params.present?
                f.write("h3. Parameters")
                f.write("\n\n")
                f.write(tabulate_params route.route_params)
                f.write("\n\n")
              end
            end
          end
        end
      end
    end

    def textile_to_html
      puts 'Converting textile to html...'

      textiles = Dir.glob(@output_path + '/**/*.textile')

      textiles.each do |textile|
        File.open(textile.gsub('.textile', '.html'), 'w') do |f|
          f.write RedCloth.new(IO.read(textile)).to_html
        end
      end
    end

    private

    def namespace_links_for_version(version, namespace)
      slashes = '../' * (namespace.count('/')-1)
      resources_string = ""
      namespaces_for_version(version).each do |resource|
        resources_string << "* \"#{titleize(resource)}\":#{slashes}#{resource.sub('/', '')}.html\n"
      end
      resources_string
    end

    def ensure_version_path_present(version)
      version_dir = File.join(@output_path, version)
      FileUtils.mkdir_p(version_dir)
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
      routes_for_version(version).select { |r| normalize_route_namespace(r) == namespace }
    end

    def titleize(string)
      string.split('/').last.titleize
    end

    def tabulate_params(params)
      string = "|_.Name|_.Type|_.Description|\n"

      params.each do |k,v|
        v = {:desc => v} unless v.is_a?(Hash)
        string << "|#{k}|#{v[:type]}|#{v[:desc]}|\n"
      end

      string
    end
  end
end
