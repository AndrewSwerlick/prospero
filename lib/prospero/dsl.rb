module Prospero
  # exposes methods that a developer can call to define a wizard.
  # Internally it simply writes all information to a hash definition of the wizard
  # which is then processed by the builder. Called by Wizard.configuration
  class DSL
    def step(name, &block)
      data[:steps] ||= []
      step = {
        base_name: name,
        show_name: "#{name}_step_show",
        update_name: "#{name}_step_update",
        order: data[:steps].count
      }

      StepDSL.new(step).instance_eval &block if block
      data[:steps] << step
    end

    def configuration
      data
    end

    private

    def data
      @data ||= {}
    end

    class StepDSL
      attr_reader :step_data

      def initialize(step_data)
        @step_data = step_data
      end

      def form(klass)
        step_data[:form] = klass
      end
    end
  end
end
