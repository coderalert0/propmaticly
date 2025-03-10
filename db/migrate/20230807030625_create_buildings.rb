# frozen_string_literal: true

class CreateBuildings < ActiveRecord::Migration[7.0]
  def change
    create_table :buildings do |t|
      t.string :name, null: false
      t.string :number
      t.string :street, null: false
      t.string :city, null: false
      t.string :state
      t.string :zip5
      t.integer :bbl
      t.integer :bin, null: false
      t.integer :community_district_borough_code, null: false
      t.integer :community_district_number, null: false
      t.json :has_properties, default: {}
      t.json :numerical_properties, default: {}
      t.references :portfolio, foreign_key: true, null: false
      t.timestamps
    end
  end
end