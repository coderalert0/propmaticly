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
      t.references :portfolio, foreign_key: true
      t.timestamps
    end
  end
end
