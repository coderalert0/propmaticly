class CreateInspections < ActiveRecord::Migration[7.0]
  def change
    create_table :inspections do |t|
      t.jsonb :data, default: {}
      t.datetime :filing_date
      t.references :building, foreign_key: true, null: false
      t.references :inspection_rule, foreign_key: true, null: false
      t.timestamps
    end
  end
end
