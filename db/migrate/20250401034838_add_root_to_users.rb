class AddRootToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :root, :boolean
  end
end
