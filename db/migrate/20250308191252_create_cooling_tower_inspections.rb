class CreateCoolingTowerInspections < ActiveRecord::Migration[7.0]
  def change
    create_table :cooling_tower_inspections do |t|
      t.string :system_id
      t.string :status
      t.integer :active_equip
      t.datetime :inspection_date
      t.string :violation_code
      t.string :law_section
      t.string :violation_text
      t.string :violation_type
      t.string :citation_text
      t.string :summons_number
      t.string :inspection_type
      t.references :building, foreign_key: true, null: false
      t.references :inspection_rule, foreign_key: true, null: false
      t.timestamps
    end
  end
end
