class CreateInspections < ActiveRecord::Migration[7.0]
  def change
    create_table :inspections do |t|
      t.integer :state, default: 0
      t.string :comment
      t.references :building, foreign_key: true
      t.timestamps
    end
  end
end
