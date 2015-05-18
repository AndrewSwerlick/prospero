require 'spec_helper'

describe Prospero::Wizard do
  let(:wizard) do
    Module.new do
      include Prospero::Wizard

      class self::Create < Prospero::Form; end
      class self::Foo < Prospero::Form; end

      configuration do
        step :create
        step :foo
      end
    end
  end

  let(:klass) do
    k = Class.new
    k.send(:include, wizard)
  end

  let(:instance){klass.new}

  describe ".model" do
    let(:result){ instance.model }
    let(:model_class) { MiniTest::Mock.new }
    before do
      klass.class_exec(model_class, params) do |mc, ps|
        define_method :model_class do
          mc
        end

        define_method :params do
          ps
        end
      end
    end

    describe "when an id param is defined" do
      let(:params) { {id: 1} }

      it "calls the model classes find method with the id" do
        model_class.expect(:find, OpenStruct.new(id: 1), [1])
        result.id.must_equal 1
        model_class.verify
      end

    end

    describe "when an id param is not defined" do
      let(:params) { {} }

      it "calls the model classes new method" do
        model_class.expect(:new, OpenStruct.new(id: nil))
        result.id.must_equal nil
        model_class.verify
      end
    end
  end

  describe ".form_for(action)" do
    before do
      klass.class_eval do
        def model
          {}
        end
      end
    end

    let(:form){instance.form_for(action)}

    describe "with a simple wizard" do


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
      let(:wizard) do
        Module.new do
          mod = self

          include Prospero::Wizard
          class self::CustomCreateStepForm < Prospero::Form; end

          configuration do
            step(:create) { form mod::CustomCreateStepForm }
            step :foo
          end

        end
      end

      it "uses the provided class" do
        form.must_be_kind_of wizard::CustomCreateStepForm
      end
    end
  end

  describe "self.register_routes_for" do
    let(:wizard) do
      Module.new do
        include Prospero::Wizard

        configuration do
          step :create
          step :foo
        end
      end
    end

    let(:routes) do
      wiz = wizard
      routes = ActionDispatch::Routing::RouteSet.new
      routes.draw do
        wiz.register_routes_for("events", self)
      end
      routes
    end

    it "creates the expected routes" do
      routes.routes.select{|r| r.name == "create_step_for_event"}.count.must_equal 1
    end
  end
end
