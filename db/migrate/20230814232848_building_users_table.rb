# frozen_string_literal: true

class BuildingUsersTable < ActiveRecord::Migration[7.0]
  def change
    create_table :building_users do |t|
      t.references :building, foreign_key: true
      t.references :user, foreign_key: true
    end
  end
end
