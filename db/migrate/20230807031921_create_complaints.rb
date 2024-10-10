# frozen_string_literal: true

class CreateComplaints < ActiveRecord::Migration[7.0]
  def change
    create_table :complaints do |t|
      t.string :complaint_id
      t.datetime :filed_date
      t.string :description
      t.string :category_code
      t.datetime :disposition_date
      t.string :disposition_code
      t.datetime :inspection_date
      t.string :link
      t.integer :state, default: 0
      t.integer :severity
      t.timestamps
      t.references :building, foreign_key: true
    end
  end
end
