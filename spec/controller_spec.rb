require 'spec_helper'

module TestWizard
  include Prospero::Wizard

  configuration do
    step :create
    step :foo
  end

  class Create < Reform::Form
  end

  class Foo < Reform::Form
  end
end

class Record
  def save
    
  end
end

Prospero::Routes.draw do
  TestWizard.register_routes_for("test", self)
end

class TestController < ActionController::Base
  include Prospero::Routes.url_helpers
  include TestWizard

  def model
    Record.new
  end

  protected

  def default_render
    render :text => action_name
  end
end

describe TestController do
  describe "get create" do
    before { get :create_step_show, id: 1}

    it "suceeds" do
      assert_response :success
    end
  end

  describe "post create" do
    before { post :create_step_update, id: 1}

    it "redirects to the next step" do
      assert_redirected_to "/test/foo/1"
    end
  end
end
