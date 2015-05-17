require 'prospero'
require 'minitest'
require 'minitest/unit'
require 'minitest/autorun'
require 'minitest/pride'
require 'minitest/around/spec'
require 'reform'
require 'pry'
require 'pry-byebug'
require 'active_support'
require 'action_controller'
require 'action_controller/test_case'
require 'rails/generators/test_case'

Reform::Form.reform_2_0!

Prospero::Routes = ActionDispatch::Routing::RouteSet.new

class ActiveSupport::TestCase
  self.test_order = :random if respond_to?(:test_order=)

  extend MiniTest::Spec::DSL

  setup do
    @routes = Prospero::Routes
  end
end

MiniTest::Spec.register_spec_type( /Controller$/,  ActionController::TestCase )
MiniTest::Spec.register_spec_type( /^Rails::Generators/, Rails::Generators::TestCase)
