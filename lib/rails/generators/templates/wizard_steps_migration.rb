class WizardSteps < ActiveRecord::Migration
  def change
    create_table :wizard_steps, :force => true do |t|
      t.integer :model_id
      t.string :name
      t.string :params
      t.string :continued_to
      t.timestamps null: false
    end

    add_index :wizard_steps, :model_id
    add_index :wizard_steps, :name
  end
end
