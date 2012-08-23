module GrapeDocumenter
  class RouteDoc
    def initialize(route, options = {})
      @route = route
      @mounted_path = options[:mounted_path] || ''
    end

    def http_method
      @route.route_method
    end

    def path
      @mounted_path + @route.route_path.gsub('(.:format)', '')
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
