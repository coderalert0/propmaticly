class CreateElevatorInspections < ActiveRecord::Migration[7.0]
  def change
    create_table :elevator_inspections do |t|
      t.string :device_number
      t.string :device_type
      t.string :device_status
      t.datetime :status_date
      t.string :equipment_type
      t.integer :periodic_report_year
      t.integer :cat1_report_year
      t.datetime :cat1_latest_report_filed
      t.datetime :cat5_latest_report_filed
      t.datetime :periodic_latest_inspection
      t.references :building, foreign_key: true, null: false
      t.references :inspection_rule, foreign_key: true, null: false
      t.timestamps
    end
  end
end
