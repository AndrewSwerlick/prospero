require 'active_support/core_ext/hash/deep_merge'

module Prospero
  module Persistence

    def adapter
      Prospero::Persistence.adapter
    end

    def after_step_save
      adapter.persist_step_data(current_step, next_action, params)
      super
    end

    def all_params
      previous_params = adapter.all_params_for(params[:id])
      previous_params.deep_merge(params).except(:id)
    end

    def params_for(step)
      adapter.params_for(step, params[:id])
    end

    class << self
      attr_reader :adapter

      def use_adapter adapter
        @adapter = adapter
      end
    end
  end
end
