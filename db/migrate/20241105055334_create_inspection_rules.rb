class CreateInspectionRules < ActiveRecord::Migration[7.0]
  def change
    create_table :inspection_rules do |t|
      t.integer :compliance_item, null: false
      t.string :description
      t.integer :frequency_in_months, null: false
      t.json :has_properties, default: {}
      t.json :numerical_properties, default: {}
      t.timestamps
    end
  end
end
