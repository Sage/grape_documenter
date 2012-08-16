require 'RedCloth'

module GrapeDoc
  module Formatters
    # For ease this uses the textile formatter first then post processes to html
    class Html
      def initialize(structure)
        @structure = structure
      end

      def format
        textile = Textile.new(@structure)
        RedCloth.new(textile.format).to_html
      end
    end
  end
end
