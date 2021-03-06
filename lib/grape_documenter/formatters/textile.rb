require 'active_support/core_ext/object/blank'

module GrapeDocumenter
  module Formatters
    # Textile
    class Textile
      def initialize(structure)
        @structure = structure
      end

      def format
        doc = @structure

        output = "h1. #{doc.title}"
        output << "\n\n"
        output << "\n\n"

        doc.routes.each do |route|
          output << "\n\n"
          output << "h2. #{route.inferred_title}"
          output << "\n\n"

          output << "\n\n"
          output << "h3. #{route.http_method}: #{route.path.gsub(':version', doc.version)}"
          output << "\n\n"

          if route.description.present?
            output << "\n\n"
            output << route.description
            output << "\n\n"
          end

          if route.params.present?
            output << "h4. Required Parameters"
            output << "\n\n"
            output << tabulate_params(route.params)
            output << "\n\n"
          end

          if route.optional_params.present?
            output << "h4. Optional Parameters"
            output << "\n\n"
            output << tabulate_params(route.optional_params)
            output << "\n\n"
          end

          output << 'h4. Example Request'
          output << "\n\n"
          output << "#{doc.root_path}__request__#{route.http_method.downcase}__#{route.inferred_rails_action}"
          output << "\n\n"

          output << 'h4. Example Response'
          output << "\n\n"
          output << "#{doc.root_path}__response__#{route.http_method.downcase}__#{route.inferred_rails_action}"
          output << "\n\n"
        end

        output
      end

      def tabulate_params(params)
        string = "table(parameters).\n"
        string += "|_.Name|_.Type|_.Description|\n"

        params.each do |k,v|
          v = {:desc => v} unless v.is_a?(Hash)
          string << "|\\3. #{k}|\n||#{v[:type]}|#{v[:desc]}|\n"
        end

        string
      end
    end
  end
end
