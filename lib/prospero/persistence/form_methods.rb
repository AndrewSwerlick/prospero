module Prospero
  module Persistence
    module FormMethods

      def all_params
        Prospero::Persistence.adapter.all_params_for(model.id)
      end

      def params_for(step)
        Prospero::Persistence.adapter.params_for(step, model.id)
      end

    end
  end
end
