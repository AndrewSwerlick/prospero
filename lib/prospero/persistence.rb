module Prospero
  module Persistence

    def after_step_save
      Prospero::Persistence.adapter.persist_step_data(params, next_action)
      super
    end

    class << self
      attr_reader :adapter

      def use_adapter adapter
        @adapter = adapter
      end
    end
  end
end
