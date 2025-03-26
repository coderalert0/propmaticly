class AddReferralToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :referral, :string
  end
end
