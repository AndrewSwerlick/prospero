require 'spec_helper'
require 'prospero/dsl'

klass = Prospero::DSL

describe klass do
  let(:dsl) {klass.new}
  let(:result) { dsl.configuration }
  describe ".step" do
    before{ dsl.step :foo }

    it "adds the step to the configuration hash" do
      result[:steps].count.must_equal 1
    end
  end
end
