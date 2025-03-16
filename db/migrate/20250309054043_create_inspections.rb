class CreateInspections < ActiveRecord::Migration[7.0]
  def change
    create_table :inspections do |t|
      t.jsonb :data, default: {}
      t.string :device_id
      t.datetime :filing_date
      t.datetime :due_date
      t.integer :state, default: 0
      t.references :building, foreign_key: true, null: false
      t.references :inspection_rule, foreign_key: true, null: false
      t.timestamps
    end
  end
end
