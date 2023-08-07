class CreateComplaints < ActiveRecord::Migration[7.0]
  def change
    create_table :complaints do |t|
      t.string :complaint_id
      t.string :filed_date
      t.string :description
      t.string :status
      t.string :category
      t.string :last_inspection_date
      t.string :last_inspection_result
      t.string :link
      t.integer :state, default: 0
      t.timestamps
    end
  end
end
