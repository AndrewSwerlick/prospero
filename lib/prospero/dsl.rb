module Prospero
  # exposes methods that a developer can call to define a wizard.
  # Internally it simply writes all information to a hash definition of the wizard
  # which is then processed by the builder. Called by Wizard.configuration
  class DSL
    def step(name)
      data[:steps] ||= []
      data[:steps] << {
        base_name: name,
        show_name: "#{name}_step_show",
        update_name: "#{name}_step_update",
        order: data[:steps].count
      }
    end

    def configuration
      data
    end

    private

    def data
      @data ||= {}
    end
  end
end
