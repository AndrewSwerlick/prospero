require 'spec_helper'

describe Prospero::Wizard do
  let(:config_block) do
    Proc.new do
      step :create
      step :foo
    end
  end
  let(:klass) do
    k = Class.new
    k.class_exec(config_block) do |config|
      include Prospero::Wizard

      configuration &config

      def model
        {}
      end

      def self.const_missing(const)
        class_eval %{
          class #{const}
            def initialize(model); end
          end
        }
        const_get(const)
      end
    end
    k
  end

  let(:instance){klass.new}

  describe ".form_for(action)" do
    let(:form){instance.form_for(action)}

    describe "with a simple configuration block" do

      describe "for the show action" do
        let(:action){ :create_step_show }

        it "it infers the form class based on the name" do
          form.must_be_kind_of klass::Create
        end
      end

      describe "form the update action" do
        let(:action){ :create_step_update }

        it "it infers the form class based on the name" do
          form.must_be_kind_of klass::Create
        end
      end
    end

    describe "with a configuration block where we define an explicit form" do
      let(:action) {:create_step_show}
      let(:config_block) do
        class CustomCreateStepForm
          def initialize(model); end
        end
        Proc.new do
          step :create do form CustomCreateStepForm end
        end
      end

      it "uses the provided class" do
        form.must_be_kind_of CustomCreateStepForm
      end
    end
  end

  describe "self.register_routes_for" do
    let(:routes) do
      wizard = klass
      routes = ActionDispatch::Routing::RouteSet.new
      routes.draw do
        wizard.register_routes_for("events", self)
      end
      routes
    end

    it "creates the expected routes" do
      routes.routes.select{|r| r.name == "create_step_for_event"}.count.must_equal 1
    end
  end
end
