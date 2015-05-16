require 'spec_helper'
require 'functional/fixtures/events_controller'
require 'functional/fixtures/test_wizard'
require 'mock_adapter'

Prospero::Routes.draw do
  TestWizard.register_routes_for("events", self)
end

describe EventsController do
  let(:wizard){ TestWizard }

  describe "base wizard" do
    before do
      EventsController.send(:include, wizard)
    end

    describe "get create" do
      before { get :create_step_show, id: 1}

      it "succeeds" do
        assert_response :success
      end
    end

    describe "post create" do
      before { post :create_step_update, id: 1}

      it "redirects to the next step" do
        assert_redirected_to "/events/foo/1"
      end

      it "has updated the model" do
        @controller.model.saved.must_equal true
      end
    end

    describe "get current" do

      describe "when the current_step is defined" do
        around {|test| @controller.stub :current_step, :foo do test.call end}
        before {get :current, id: 1}

        it "redirects to the current step" do
          assert_redirected_to "/events/foo/1"
        end
      end

      describe "when the current_step is not defined" do
        around {|test| @controller.stub :current_step, nil do test.call end}
        before {get :current, id: 1}

        it "redirects to the first step" do
          assert_redirected_to "/events/create/1"
        end
      end
    end

  end

  describe "include Prospero::Persistence" do
    before do
      Prospero::Persistence.use_adapter adapter
      wizard.send(:include, Prospero::Persistence)
      EventsController.send(:include, wizard)
    end

    let(:adapter) {MockAdapter.new }

    describe "post create" do
      before { post :create_step_update, id: 1}

      it "creates a new wizard step entry for the model object with the method is called" do
        adapter.steps.select{|s| s.id == "1"}.count.must_equal 1
      end
    end
  end
end
