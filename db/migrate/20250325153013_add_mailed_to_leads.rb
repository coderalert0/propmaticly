class AddMailedToLeads < ActiveRecord::Migration[7.2]
  def change
    add_column :leads, :mailed, :boolean
  end
end
