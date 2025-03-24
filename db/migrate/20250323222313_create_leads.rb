class CreateLeads < ActiveRecord::Migration[7.2]
  def change
    create_table :leads do |t|
      t.string :entity_name, null: false
      t.string :chairman_name
      t.string :agent_name
      t.string :agent_address
      t.string :agent_city
      t.string :agent_state
      t.string :agent_zip_code
      t.string :process_name
      t.string :process_address, null: false
      t.string :process_city, null: false
      t.string :process_state
      t.string :process_zip_code, null: false
      t.integer :penalty_imposed, null: false
      t.integer :amount_paid
      t.integer :balance_due
      t.string :ecb_violation_number
      t.date :issue_date
      t.timestamps
    end
  end
end
