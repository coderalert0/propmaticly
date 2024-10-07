# frozen_string_literal: true

class CreateViolations < ActiveRecord::Migration[7.0]
  def change
    create_table :violations do |t|
      t.string :number
      t.string :type_code
      t.integer :state, default: 0
      t.string :description
      t.string :comments
      t.references :building, foreign_key: true
      t.timestamp :issue_date
      t.timestamp :disposition_date
      t.timestamps
    end
  end
end
