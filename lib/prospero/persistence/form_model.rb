module Prospero
  module Persistence
    class FormModel
      attr_reader :model
      attr_reader :params

      def initialize(model, params)
        @model = model
        @params = OpenStruct.new(params)
      end

      def original
        model
      end

      def method_missing(method, *args, &block)
        value = nil

        if model.respond_to?(method)
          value = model.send(method, *args, &block)
        end

        if value == nil && params.respond_to?(method)
          value = params.send(method, *args, &block)
        end

        value
      end

      def respond_to?(method)
        super || model.respond_to?(method) || params.respond_to?(method)
      end
    end
  end
end
