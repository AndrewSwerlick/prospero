require 'ostruct'
module Prospero
  class Builder
    attr_reader :configuration

    def initialize(configuration)
      @configuration = configuration
    end

    def next_action(action_name)
      st = step_map[action_name]
      next_st = steps[st[:order] + 1 ]
      next_st ? next_st[:show_name] : st[:show_name]
    end

    def build_in(base)
      builder = self
      base.class_exec(configuration) do |config|
        @wizard_config = config

        steps.each do |st|
          define_method st[:show_name] do
          end

          define_method, st[:update_name] do
            action = builder.next_action(st[:update_name])
            path = url_for(:controller => controller_name, :action => action, :id => params[:id])
            redirect_to path
          end
        end
      end
    end

    private
    def step_map
      @map = begin
        kv = steps.map do |s|
          [[s[:update_name], s], [s[:show_name], s]]
        end.flatten(1)
        Hash[kv]
      end
    end

    def steps
      configuration[:steps].sort_by{|s| s[:order]}
    end
  end
end
