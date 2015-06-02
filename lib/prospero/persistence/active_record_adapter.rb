require 'active_record'

module Prospero
  module Persistence
    class ActiveRecordAdapter
      class WizardStep < ActiveRecord::Base
        def self.table_name
          "wizard_steps"
        end

        serialize :params
      end

      def persist_step_data(id, step_name, next_action, params)
        step = WizardStep.find_by(model_id: id, name: step_name)
        unless step
          WizardStep.create(model_id: id, name: step_name, continued_to: next_action, params: params)
        else
          step.params = params
          step.save!
        end

      end

      def all_params_for(id)
        steps = WizardStep.where(model_id: id).order(updated_at: :asc)
        steps.inject({}) do |hash, step|
          hash.merge step.params
        end
      end

      def params_for(step, id)
        WizardStep.find_by(model_id: id, name: step).try(:params)
      end

      def transitions
        WizardStep.find_by(model_id: id).pluck(:step_name, :continued_to).order(updated_at: :asc)
      end
    end
  end
end
