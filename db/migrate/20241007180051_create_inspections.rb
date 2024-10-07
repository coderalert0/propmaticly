# frozen_string_literal: true

class CreateInspections < ActiveRecord::Migration[7.0]
  def change
    create_table :inspections do |t|
      t.integer :state, default: 0
      t.string :description
      t.references :building, foreign_key: true
      t.timestamps
    end
  end
end
