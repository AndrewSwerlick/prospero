class MockAdapter
  attr_reader :steps

  def initialize
    @steps = []
  end

  def persist_step_data(id, step_name, next_action, params)
    steps << OpenStruct.new(name: step_name, id: id, params: params.except(:id), continued_to: next_action)
  end

  def all_params_for(id)
    steps.select{|s| s.id == id}.inject({}) do |hash, step|
      hash.merge(step.params)
    end
  end

  def params_for(step, id)
    steps.find{|s| s.id == id && s.name == step}.try { |s| s[:params] }
  end
end
