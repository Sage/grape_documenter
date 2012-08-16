module GrapeDoc
  class RouteDoc
    def initialize(route)
      @route = route
    end

    def http_method
      @route.route_method
    end

    def path
      @route.route_path
    end

    def description
      @route.route_description
    end

    def params
      @route.route_params
    end

    def optional_params
      @route.route_optional_params
    end
  end
end
