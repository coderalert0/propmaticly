class CreateBedBugInspections < ActiveRecord::Migration[7.0]
  def change
    create_table :bed_bug_inspections do |t|
      t.string :registration_id
      t.integer :of_dwelling_units
      t.integer :infested_dwelling_unit_count
      t.integer :eradicated_unit_count
      t.integer :re_infested_dwelling_unit
      t.datetime :filing_date
      t.datetime :filing_period_start_date
      t.datetime :filling_period_end_date
      t.references :building, foreign_key: true, null: false
      t.references :inspection_rule, foreign_key: true, null: false
      t.timestamps
    end
  end
end
