# frozen_string_literal: true

class CreateBuildings < ActiveRecord::Migration[7.0]
  def change
    create_table :buildings do |t|
      t.string :name
      t.string :number
      t.string :street, null: false
      t.string :city, null: false
      t.string :state
      t.string :zip5
      t.integer :bbl
      t.integer :bin
      t.integer :square_feet
      t.integer :tax_lot_square_feet
      t.integer :number_of_stories
      t.integer :boiler_btus
      t.boolean :has_elevator
      t.boolean :has_sprinklers
      t.boolean :has_standpipe
      t.boolean :has_backflow
      t.boolean :has_cooling_tower
      t.integer :number_of_residential_units
      t.boolean :has_gas_piping
      t.boolean :has_units_with_children_under_10
      t.references :portfolio, foreign_key: true
      t.timestamps
    end
  end
end
