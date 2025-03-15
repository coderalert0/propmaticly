class CreateInspectionRules < ActiveRecord::Migration[7.0]
  def change
    create_table :inspection_rules do |t|
      t.integer :compliance_item, null: false
      t.string :description
      t.integer :department
      t.integer :frequency_in_months, null: false
      t.boolean :based_on_last_inspection
      t.jsonb :fixed_day_month
      t.jsonb :cycle_schedule
      t.jsonb :has_properties, default: {}
      t.jsonb :numerical_properties, default: {}
      t.string :type
      t.timestamps
    end
    add_index :inspection_rules, :compliance_item, unique: true
  end
end
