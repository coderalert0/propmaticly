# frozen_string_literal: true

class AssetContact < ApplicationRecord
  belongs_to :user
  belongs_to :assignable, polymorphic: true

  validates :user_id, :assignable_type, :assignable_id, presence: true

  def self.assign_assets_to_user(assignable_type, assignable_ids, user)
    AssetContact.where(user: user, assignable_type: assignable_type).destroy_all

    assignable_ids&.reject(&:blank?)&.each do |assignable_id|
      AssetContact.create(user: user, assignable: assignable_type.constantize.find(assignable_id))
    end
  end
end
