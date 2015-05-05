require 'prospero/dsl'
require 'prospero/builder'

module Prospero
  # Module that exposes the public API of Prospero to end-developers. Includes all
  # other key modules and orchestrates the rest of the Prospero components
  module Wizard

    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def configuration(&block)
        config = DSL.new.tap {|d| d.instance_exec(&block) }.configuration
        Builder.new(config).build_in(self)
      end

      def register_routes_for(controller, router)
        steps = @wizard_config[:steps]
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
