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

    def model
      params[:id] ? model_class.find(params[:id]) : model_class.new
    end

    def model_class
      controller_name.classify.constantize
    end

    def after_step_save
    end

    def current_step
      action_map[action_name][:base_name]
    end

    def form_for(action)
      step = action_map[action.to_s]
      name = step[:base_name]
      form_class = step[:form] || self.class.const_get("#{name}".classify)
      form_class.new(model)
    end

    def action_map
      @action_map ||= wizard_configuration[:steps].inject({}) do |hash, step|
        hash[step[:show_name]] = step
        hash[step[:update_name]] = step
        hash
      end
    end

    def step_map
      @step_map ||= wizard_configuration[:steps].inject({}) do |hash, step|
        hash[step[:base_name]] = step
        hash
      end
    end

    def next_action
      current = action_map[action_name]
      next_step = steps[current[:order] + 1 ]
      next_step ? next_step[:show_name] : current[:show_name]
    end

    def steps
      @steps ||= wizard_configuration[:steps].sort_by {|s| s[:order]}
    end

    module ClassMethods
      def configuration(&block)
        config = DSL.new.tap {|d| d.instance_exec(&block) }.configuration
        Builder.new(config).build_in(self)
      end

      def register_routes_for(controller, router)
        steps = wizard_configuration[:steps]
        router.instance_exec steps, controller do |steps, controller|
          steps.each do |step|
            get "#{controller}/#{step[:base_name]}/:id",
                to: "#{controller}##{step[:show_name]}", as: "#{step[:base_name]}_step_for_#{controller.singularize}"
            post "#{controller}/#{step[:base_name]}/:id",
                to: "#{controller}##{step[:update_name]}"
          end

          get "#{controller}/current/:id", to: "#{controller}#current"
        end
      end
    end
  end
end
