class CreateFacadeInspections < ActiveRecord::Migration[7.0]
  def change
    create_table :facade_inspections do |t|
      t.string :tr6_no
      t.string :control_no
      t.string :filing_type
      t.integer :cycle
      t.integer :sequence_no
      t.datetime :submitted_on
      t.string :current_status
      t.string :qewi_name
      t.string :qewi_bus_name
      t.string :qewi_nys_lic_no
      t.datetime :qewi_signed_date
      t.datetime :filing_date
      t.string :filing_status
      t.datetime :field_inspection_completed_date
      t.integer :late_filing_amt
      t.integer :failure_to_file_amt
      t.integer :failure_to_collect_amt
      t.string :comments
      t.references :building, foreign_key: true, null: false
      t.references :inspection_rule, foreign_key: true, null: false
      t.timestamps
    end
  end
end
