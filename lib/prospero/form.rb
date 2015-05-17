module Prospero
  class Form < Reform::Form
    alias_method :safe_params, :to_hash
  end
end
