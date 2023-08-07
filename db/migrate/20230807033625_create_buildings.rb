class CreateBuildings < ActiveRecord::Migration[7.0]
  def change
    create_table :buildings do |t|
      t.integer :street_number
      t.string :street_name
      t.string :subpremise
      t.string :city
      t.string :state
      t.integer :zip_code
      t.string :email_address
      t.string :sms
      t.timestamps
    end
  end
end
