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
      form_class = step[:form] || wizard_module.const_get("#{name}".classify)
      form = form_class.new(model)
      form.singleton_class.instance_exec(step) do |step |
        define_method "model_name" do
          Prospero::ModelName.new(form.class, nil, nil,step, step[:route_name])
        end
      end
      form
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

      def register_routes_for(router)
        router.instance_exec wizard_configuration do |wizard_configuration|
          steps = wizard_configuration[:steps]
          route_namespace = wizard_configuration[:route_namespace]

          steps.each_with_index do |step, ind|
            id_part = ":id"
            id_part = "(:id)" if ind == 0

            route_name = "#{step[:route_name]}"

            get "#{route_namespace}/#{step[:base_name]}/#{id_part}",
                to: "#{route_namespace}##{step[:show_name]}", as: route_name
            post "#{route_namespace}/#{step[:base_name]}/#{id_part}",
                to: "#{route_namespace}##{step[:update_name]}"
            patch "#{route_namespace}/#{step[:base_name]}/#{id_part}",
                to: "#{route_namespace}##{step[:update_name]}"

            step[:route_name] = route_name
          end

          get "#{route_namespace}/current/:id", to: "#{route_namespace}#current"
        end
      end
    end
  end
end
