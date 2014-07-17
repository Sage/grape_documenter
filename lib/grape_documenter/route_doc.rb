require 'active_support/inflector'

module GrapeDocumenter
  # Route Doc
  class RouteDoc
    include  ActiveSupport::Inflector
    def initialize(route, options = {})
      @route = route
      @mounted_path = options[:mounted_path] || ''
      @action = options[:action] || ''
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

    def action_params
      @action
    end

    def inferred_title
      "To #{inferred_action} #{inferred_resource}"
    end

    def inferred_rails_action
      case http_method
      when 'GET'
        inferred_action_from_params
      when 'PUT'
        'update'
      when 'POST'
        'create'
      when 'DELETE'
        'destroy'
      end
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
        indefinite_articlerize(humanize(resource.singularize))
      else
        "a list of #{humanize(resource.pluralize)}"
      end
    end

    def inferred_singular?
      path.include?(':id') || http_method == 'POST'
    end

    def inferred_action_from_params
      return action_params unless action_params.blank?
      inferred_singular? ? 'show' : 'index'
    end

    def path_without_format
      @route.route_path.gsub('(.:format)', '')
    end

    def indefinite_articlerize(word)
      %w(a e i).include?(word[0].downcase) ? "an #{word}" : "a #{word}"
    end
  end
end
