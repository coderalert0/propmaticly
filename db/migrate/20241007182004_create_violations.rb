# frozen_string_literal: true

class CreateViolations < ActiveRecord::Migration[7.0]
  def change
    create_table :violations do |t|
      t.string :violation_id, null: false
      t.integer :state, default: 0
      t.datetime :issue_date
      t.integer :severity
      t.string :violation_type
      t.string :description
      t.string :device_number
      t.string :device_type
      t.references :building, foreign_key: true, null: false
      t.string :type
      t.timestamps
    end
  end
end
