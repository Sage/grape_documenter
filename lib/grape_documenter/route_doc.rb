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

    def inferred_title
      "To #{inferred_action} a #{inferred_resource}"
    end

    private

    # get / create / delete /update
    def inferred_action
      case http_method
      when 'GET'
        'get'
      when 'PUT'
        'update'
      when 'DELETE'
        'delete'
      end
    end

    def inferred_resource
      items = path.split('/')
      resource = items.reject{|i| i.blank? }.first

      if inferred_singular?
        resource.singularize
      else
        "list of #{resource.pluralize}"
      end
    end

    def inferred_singular?
      path.include?(':id')
    end
  end
end
