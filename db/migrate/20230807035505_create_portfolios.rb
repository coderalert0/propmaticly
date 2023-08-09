# frozen_string_literal: true

class CreatePortfolios < ActiveRecord::Migration[7.0]
  def change
    create_table :portfolios do |t|
      t.string :name
      t.string :description
      t.string :email_address
      t.references :organization, foreign_key: true, null: false
      t.timestamps
    end
  end
end
