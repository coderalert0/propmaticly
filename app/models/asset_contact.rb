# frozen_string_literal: true

class AssetContact < ApplicationRecord
  belongs_to :user
  belongs_to :assignable, polymorphic: true

  validates :user_id, :assignable_type, :assignable_id, presence: true
end
