# require 'spec_helper'
# require 'mock_adapter'
#
# Prospero::Persistence.use_adapter MockAdapter.new
#
# describe Prospero::Persistence do
#   let(:wizard) do
#     Module.new do
#       include Prospero::Wizard
#       include Prospero::Persistence
#
#       configuration do
#         step :create
#         step :foo
#       end
#     end
#   end
#
#   let(:klass) do
#     k = Class.new
#     k.class_exec(wizard, params) do |wizard, param_hash|
#       include wizard
#
#       def params
#         param_hash
#       end
#     end
#     k
#   end
#
#   let(:instance){klass.new}
#   let(:params){ { id: 1, create: {foo:"bar" } } }
#
#   describe ".create_step_update" do
#     before { instance.create_step_update }
#     it "creates a new wizard step entry for the model object with the method is called" do
#       MockAdapter.find_by_model_id(1).count.must_equal 1
#     end
#   end
# end
