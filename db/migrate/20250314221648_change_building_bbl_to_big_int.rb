class ChangeBuildingBblToBigInt < ActiveRecord::Migration[7.2]
  def up
    change_column :buildings, :bbl, :bigint
  end

  def down
    change_column :buildings, :bbl, :int
  end
end
