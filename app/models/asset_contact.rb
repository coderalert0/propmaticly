# frozen_string_literal: true

class AssetContact < ApplicationRecord
  belongs_to :user
  belongs_to :assignable, polymorphic: true
end
