require 'active_support/core_ext/hash/deep_merge'
require 'prospero/persistence/param_methods'
require 'prospero/persistence/form_methods'

module Prospero
  module Persistence
    autoload :ActiveRecordAdapter, 'prospero/persistence/active_record_adapter'
    include ParamMethods

    def adapter
      Prospero::Persistence.adapter
    end

    def after_step_save
      adapter.persist_step_data(params[:id], current_step, next_action, form.safe_params)
      super
    end

    def form_for(step)
      form = super
      form.extend FormMethods
      form
    end

    def furthest_step
      (adapter.transitions.map{|t| t[0]} - adapter.transitions.map{|t| t[1]}).last || steps.first[:base_name]
    end

    class << self
      attr_reader :adapter

      def use_adapter adapter
        @adapter = adapter
      end
    end
  end
end
