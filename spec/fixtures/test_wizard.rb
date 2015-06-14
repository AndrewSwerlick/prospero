module TestWizard
  include Prospero::Wizard

  configuration do
    route_namespace :events
    step :create
    step :schedule
  end

  class Create < Prospero::Form
    property :name
  end

  class Schedule < Prospero::Form
    property :start_date_time
    property :end_date_time
  end
end
