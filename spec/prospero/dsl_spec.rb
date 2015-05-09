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

  describe ".step do &block end" do
    before {dsl.step :foo, &block}

    describe ".form" do
      class Form; end
      let(:block) {Proc.new {form Form}}

      it "adds the form to the step configuration hash" do
        result[:steps].first[:form].must_equal Form
      end
    end
  end


end
