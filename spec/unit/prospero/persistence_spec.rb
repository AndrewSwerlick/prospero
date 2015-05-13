require 'spec_helper'
require 'mock_adapter'

Prospero::Persistence.use_adapter MockAdapter.new

describe Prospero::Persistence do
  let(:wizard) do
    Module.new do
      include Prospero::Wizard
      include Prospero::Persistence

      configuration do
        step :create
        step :foo
      end
    end
  end

  let(:klass) do
    k = Class.new
    k.class_exec(wizard, params) do |wizard, param_hash|
      include wizard

      define_method "params" do
        param_hash
      end
    end
    k
  end

  let(:instance){klass.new}
  let(:adapter) { MockAdapter.new }
  let(:params){ { id: 1, create: {foo:"bar" } } }

  before {Prospero::Persistence.use_adapter adapter}

  describe ".all_params" do
    let(:result) { instance.all_params }

    describe "when there is no persisted step data" do
      it "returns an the current params except id" do
        result.must_equal params.except(:id)
      end
    end

    describe "when there are steps persisted for the current model" do
      before {adapter.steps << OpenStruct.new(id: 1, )}

      it "returns a merged hash with params from both" do
        skip
      end
    end
  end
end
