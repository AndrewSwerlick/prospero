require 'ostruct'
module Prospero
  class Builder
    attr_reader :configuration

    def initialize(configuration)
      @configuration = configuration
    end

    def build_in(base)
      base.class_exec(configuration, self) do |config, builder|

        define_singleton_method "included" do |base|
          base.send(:helper_method, :form)
        end

        define_singleton_method "wizard_configuration" do
          config
        end

        define_method "wizard_configuration" do
          base.wizard_configuration
        end

        builder.steps.each do |st|
          define_method st[:show_name] do

          end

          define_method st[:update_name] do
            path = url_for(:controller => controller_name, :action => next_action, :id => params[:id])
            if form.validate(params)
              form.save
              after_step_save
              redirect_to path
            end
          end
        end

        define_method "current" do
          step = step_map[current_step] || steps.first
          path = url_for(:controller => controller_name, :action => step[:show_name], :id => params[:id])
          redirect_to path
        end
      end
    end

    def steps
      configuration[:steps].sort_by{|s| s[:order]}
    end
  end
end
