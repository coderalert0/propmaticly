class CreateComplaints < ActiveRecord::Migration[7.0]
  def change
    create_table :complaints do |t|
      t.string :complaint_id
      t.datetime :filed_date
      t.string :description
      t.string :status
      t.string :category
      t.datetime :last_inspection_date
      t.string :last_inspection_result
      t.string :link
      t.integer :state, default: 0
      t.timestamps
      t.references :building, foreign_key: true
    end
  end
end
