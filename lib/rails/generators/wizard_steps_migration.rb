require 'rails/generators/migration'
require 'rails/generators/active_record'

module Rails
  module Generators
    class WizardStepsMigration < Rails::Generators::Base
      include Rails::Generators::Migration

      desc "Generates a migration for prospero wizard steps"

      def self.source_root
        @source_root ||= File.dirname(__FILE__) + '/templates'
      end

      def self.next_migration_number(path)
        ActiveRecord::Generators::Base.next_migration_number(path)
      end

      def generate_migration
        migration_template 'wizard_steps_migration.rb', 'db/migrate/wizard_steps.rb'
      end
    end
  end
end
