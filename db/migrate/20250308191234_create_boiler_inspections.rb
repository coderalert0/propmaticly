class CreateBoilerInspections < ActiveRecord::Migration[7.0]
  def change
    create_table :boiler_inspections do |t|
      t.string :tracking_number
      t.string :boiler_id
      t.string :report_type
      t.string :applicantfirst_name
      t.string :applicant_last_name
      t.string :applicant_license_type
      t.string :applicant_license_number
      t.string :boiler_make
      t.string :boiler_model
      t.string :pressure_type
      t.string :inspection_type
      t.datetime :inspection_date
      t.string :defects_exist
      t.integer :lff_45_days
      t.integer :lff_180_days
      t.integer :filing_fee
      t.integer :total_amount_paid
      t.string :report_status
      t.references :building, foreign_key: true, null: false
      t.references :inspection_rule, foreign_key: true, null: false
      t.timestamps
    end
  end
end
