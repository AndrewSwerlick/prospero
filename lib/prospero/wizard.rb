require 'prospero/dsl'
require 'prospero/builder'

module Prospero
  # Module that exposes the public API of Prospero to end-developers. Includes all
  # other key modules and orchestrates the rest of the Prospero components
  module Wizard

    def self.included(base)
      base.extend ClassMethods
    end

    def form
      @form ||= form_for(action_name)
    end

    def form_for(action)
      action_map = wizard_configuration[:steps].inject({}) do |hash, step|
        hash[step[:show_name]] = step
        hash[step[:update_name]] = step
        hash
      end
      step = action_map[action.to_s]
      name = step[:base_name]
      form_class = step[:form] || self.class.const_get("#{name}".classify)
      form_class.new(model)
    end

    def next_action
      steps = wizard_configuration[:steps].sort_by {|s| s[:order]}
      current = steps.find{|s| s[:update_name] == action_name}
      next_step = steps[current[:order] + 1 ]
      next_step ? next_step[:show_name] : current[:show_name]
    end

    module ClassMethods
      def included(base)
        base.helper_method :form
      end

      def configuration(&block)
        config = DSL.new.tap {|d| d.instance_exec(&block) }.configuration
        Builder.new(config).build_in(self)
      end

      def register_routes_for(controller, router)
        steps = wizard_configuration[:steps]
        router.instance_exec steps, controller do |steps, controller|
          steps.each do |step|
            get "#{controller}/#{step[:base_name]}/:id", to: "#{controller}##{step[:show_name]}"
            post "#{controller}/#{step[:base_name]}/:id", to: "#{controller}##{step[:update_name]}"
          end
        end
      end
    end
  end
end
