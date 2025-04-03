class CreateNotifications < ActiveRecord::Migration[7.0]
  def change
    create_table :notifications do |t|
      t.references :user, null: false, foreign_key: true
      t.references :notifiable, polymorphic: true, null: false
      t.timestamps
    end

    add_index :notifications, [:notifiable_type, :notifiable_id, :user_id], unique: true, name: "index_notifications_on_notifiable_and_user"
  end
end
