require 'RedCloth'

module GrapeDoc
  module Formatters
    # For ease this uses the textile formatter first then post processes to html
    class Html
      def initialize(structure, generator)
        @structure = structure
        @generator = generator
      end

      def format
        textile = Textile.new(@structure, @generator)
        RedCloth.new(textile.format).to_html
      end
    end
  end
end
