module TestWizard
  include Prospero::Wizard
  
  configuration do
    step :create
    step :foo
  end

  class Create < Reform::Form
  end

  class Foo < Reform::Form
  end
end
