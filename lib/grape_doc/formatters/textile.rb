module GrapeDoc
  module Formatters
    class Textile
      def initialize(structure, generator)
        @structure = structure
        @generator = generator
      end

      def format
        doc = @structure

        output = "h1. #{doc.title}"
        output << "\n\n"
        output << @generator.namespace_links_for_version(doc.version, doc.root_path)
        output << "\n\n"

        doc.routes.each do |route|
          output << "\n\n"
          output << "h2. #{route.route_method}: #{route.route_path.gsub(':version', doc.version)}"
          output << "\n\n"

          if route.route_description.present?
            output << "h3. Description"
            output << "\n\n"
            output << route.route_description
            output << "\n\n"
          end

          if route.route_params.present?
            output << "h3. Parameters"
            output << "\n\n"
            output << tabulate_params(route.route_params)
            output << "\n\n"
          end
        end

        output
      end

      private

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
end
