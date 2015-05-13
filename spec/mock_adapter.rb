class MockAdapter
  attr_reader :steps

  def initialize
    @steps = []
  end

  def persist_step_data(params, next_action)
    steps << OpenStruct.new(params.merge(continued_to: next_action))
  end

  def find_by_model_id(id)
    steps.select{|s| s.id == id.to_s}
  end
end
