module ParamMethods
  def all_params
    previous_params = Prospero::Persistence.adapter.all_params_for(model.id)
    previous_params.deep_merge(params).except(:id)
  end

  def params_for(step)
    Prospero::Persistence.adapter.params_for(step, model.id)
  end
end
