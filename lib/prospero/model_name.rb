module Prospero
  class ModelName < ActiveModel::Name
    def initialize(klass, namespace=nil, name=nil, step, route_target)
      super(klass, namespace, name)
      @route_key = "#{step[:base_name]}_step_for_#{route_target}"
      @singular_route_key = "#{step[:base_name]}_step_for_#{route_target}"
    end
  end
end
