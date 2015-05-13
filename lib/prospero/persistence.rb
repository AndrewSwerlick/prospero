module Prospero
  module Persistence

    def adapter
      Prospero::Persistence.adapter
    end

    def after_step_save
      adapter.persist_step_data(params, next_action)
      super
    end

    def all_params
      params.except(:id)
    end

    def params_for(step)
    end

    class << self
      attr_reader :adapter

      def use_adapter adapter
        @adapter = adapter
      end
    end
  end
end
