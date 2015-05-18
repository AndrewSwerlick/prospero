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


class Minitest::Spec

  # def self.let name, &block
  #   name = name.to_s
  #   pre, post = "let '#{name}' cannot ", ". Please use another name."
  #   methods = Minitest::Spec.instance_methods.map(&:to_s) - %w[subject]
  #   raise ArgumentError, "#{pre}begin with 'test'#{post}" if
  #     name =~ /\Atest/
  #   raise ArgumentError, "#{pre}override a method in Minitest::Spec#{post}" if
  #     methods.include? name
  #
  #   mod = Module.new do
  #     define_method name, &block
  #   end
  #
  #   memo_mod = Module.new do
  #
  #     define_method name do
  #       @_memoized ||= {}
  #       @_memoized.fetch(name) do |k|
  #         @_memoized[k] = super()
  #       end
  #     end
  #   end
  #
  #   self.send(:include, mod)
  #   self.send(:include, memo_mod)
  # end

end

MiniTest::Spec.register_spec_type( /Controller$/,  ActionController::TestCase )
MiniTest::Spec.register_spec_type( /^Rails::Generators/, Rails::Generators::TestCase)
