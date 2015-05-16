require 'spec_helper'
require 'rails/generators/test_case'
require 'rails/generators/wizard_steps_migration'

describe Rails::Generators::WizardStepsMigration do
  tests Rails::Generators::WizardStepsMigration
  destination File.expand_path('../../tmp', File.dirname(__FILE__))
  setup :prepare_destination

  it "creates the migration files" do
    run_generator

    assert_migration "db/migrate/wizard_steps.rb" do |migration|
      assert_instance_method :change, migration do |change|
        assert_match(%r{create_table}, change)
      end
    end
  end

end
