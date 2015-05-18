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

      def current_step
        :create
      end

      def next_action
        :foo
      end

      def form
        self.class.const_get("Create").new({})
      end

      class self::Create < Prospero::Form
        property :foo, virtual: true
        property :bar, virtual: true
      end

      class self::Foo < Prospero::Form
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

      def model
        OpenStruct.new(id: 1)
      end

    end
    k
  end

  let(:instance){klass.new}
  let(:adapter) { MockAdapter.new }
  let(:params){ { id: 1, foo:"bar" } }

  before {Prospero::Persistence.use_adapter adapter}

  describe ".all_params" do
    let(:result) { instance.all_params }

    describe "when there is no persisted step data" do
      it "returns an the current params except id" do
        result.must_equal params.except(:id)
      end
    end

    describe "when there are steps persisted for the current model" do
      before {adapter.persist_step_data(1, :create, nil, bar: "foo") }

      it "returns a merged hash with params from both" do
        expected = {
          bar: "foo",
          foo: "bar"
        }
        result.must_equal expected
      end
    end
  end

  describe ".after_step_save" do
    before do
      instance.form.validate(params)
      instance.after_step_save
    end

    describe "when called with params that aren't safe" do
      let(:params){ {bad_param: "test" } }

      it "does not save the bad data" do
        adapter.steps.first.params[:bad_param].must_be_nil
      end
    end
  end

  describe ".params_for(step)" do
    let(:step){:create}
    let(:result){instance.params_for(step)}
    describe "when there are steps persisted for the current model" do
      before {adapter.persist_step_data(1,:create, nil, bar: "foo") }

      it "returns the step data" do
        expected = {bar: "foo"}
        result.must_equal expected
      end
    end
  end

  describe ".form_for(step)" do
    let(:result){ instance.form_for(:create_step_show) }

    it "returns a form with the .all_params method included" do
      result.respond_to?(:all_params).must_equal true
    end

    it "returns a form with the .params_form method included" do
      result.respond_to?(:params_for).must_equal true
    end
  end

  describe ".form_model" do
    let(:result){instance.form_model}
    describe "when there are steps persisted for the current model" do
      before {adapter.persist_step_data(1,:create, nil, bar: "foo") }

      it "returns a form_model where the data is loaded" do
        result.bar.must_equal "foo"
      end
    end
  end
end
