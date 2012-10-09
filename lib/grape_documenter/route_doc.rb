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
      @mounted_path + path_without_format
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
      "To #{inferred_action} #{inferred_resource}"
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
      when 'POST'
        'create'
      end
    end

    def inferred_resource
      items = path_without_format.split('/')
      resource = items.reject{|i| i.blank? }.reject{|j| j.start_with?(':') }.last

      if inferred_singular?
        indefinite_articlerize resource.singularize
      else
        "a list of #{resource.pluralize}"
      end
    end

    def inferred_singular?
      path.include?(':id') || http_method == 'POST'
    end

    def path_without_format
      @route.route_path.gsub('(.:format)', '')
    end

    def indefinite_articlerize(word)
      %w(a e i).include?(word[0].downcase) ? "an #{word}" : "a #{word}"
    end
  end
end
