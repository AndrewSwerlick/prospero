module Prospero
  module Persistence
    module FormMethods

      def self.extended(base)
        mod = Module.new
        mod.module_exec(base.all_params) do |params|
          params.keys.each do |param|
            define_method param do
              if defined?(super)
                super().nil? ? all_params[param] : super()
              else
                all_params[param]
              end
            end
          end
        end

        base.extend(mod)
      end

      def all_params
        Prospero::Persistence.adapter.all_params_for(model.id)
      end

      def params_for(step)
        Prospero::Persistence.adapter.params_for(step, model.id)
      end

    end
  end
end
