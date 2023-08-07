class CreateBuildings < ActiveRecord::Migration[7.0]
  def change
    create_table :buildings do |t|
      t.integer :street_number
      t.string :street_name
      t.string :subpremise
      t.string :city
      t.string :administrative_area
      t.string :postal_code
      t.string :email_address
      t.string :sms
      t.references :portfolio, foreign_key: true
      t.timestamps
    end
  end
end
