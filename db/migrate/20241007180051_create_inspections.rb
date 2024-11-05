# frozen_string_literal: true

class CreateInspections < ActiveRecord::Migration[7.0]
  def change
    create_table :inspections do |t|
      t.datetime :date, null: false
      t.string :device_number
      t.integer :device_status
      t.references :inspection_rule, foreign_key: true, null: false
      t.references :building, foreign_key: true, null: false
      t.timestamps
    end
  end
end
