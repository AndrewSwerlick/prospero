require 'prospero'
require 'minitest'
require 'minitest/unit'
require 'minitest/autorun'
require 'minitest/pride'
require 'pry'
require 'pry-byebug'
require 'active_support'
require 'action_controller'
require 'action_controller/test_case'


Prospero::Routes = ActionDispatch::Routing::RouteSet.new
Prospero::Routes.draw do

end

class ActiveSupport::TestCase
  self.test_order = :random if respond_to?(:test_order=)

  extend MiniTest::Spec::DSL

  setup do
    @routes = Prospero::Routes
  end
end

MiniTest::Spec.register_spec_type( /Controller$/,  ActionController::TestCase )
