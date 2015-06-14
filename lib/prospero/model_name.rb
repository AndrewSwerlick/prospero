module Prospero
  class ModelName < ActiveModel::Name
    def initialize(klass, namespace=nil, name=nil, step, route_name)
      super(klass, namespace, name)
      @route_key = route_name
      @singular_route_key = route_name
    end
  end
end
