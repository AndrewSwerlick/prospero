require 'spec_helper'
require 'active_record'




klass = Prospero::Persistence::ActiveRecordAdapter

describe Prospero::Persistence::ActiveRecordAdapter do
  before do
    ActiveRecord::Base.establish_connection(:adapter => "sqlite3", :database => ":memory:")

    ActiveRecord::Schema.define do
      self.verbose = false

      create_table :wizard_steps, :force => true do |t|
       t.integer :model_id
       t.string :name
       t.string :params
       t.string :continued_to
       t.timestamps null: false
      end
    end
  end
  let(:adapter){ klass.new }

  describe ".persist_step_data(step_name, next_action, params)" do
    before { adapter.persist_step_data(1, :create, :foo, { name: "test"}) }

    it "adds a new wizard step to the database" do
      klass::WizardStep.count.must_equal 1
    end

    describe "when called with the same data twice" do
      before { adapter.persist_step_data(1, :create, :foo, { name: "test"}) }

      it "only creates one record" do
        klass::WizardStep.count.must_equal 1
      end
    end
  end

  describe ".all_params_for(id)" do
    let(:params){ adapter.all_params_for(1) }

    describe "with one step persisted" do
      before { adapter.persist_step_data(1, :create, :foo, { name: "test"}) }

      it "has the step data" do
        expected = {name: "test"}
        params.must_equal expected
      end
    end
  end

  describe "params_for(step, id)" do
    let(:params){ adapter.params_for(:create, 1) }

    describe "when the step has been persisted" do
      before { adapter.persist_step_data(1, :create, :foo, { name: "test"}) }

      it "has the step_data" do
        expected = {name: "test"}
        params.must_equal expected
      end
    end

    describe "when the step has not been persisted" do
      it "returns nil" do
        params.must_be_nil
      end
    end
  end
end
