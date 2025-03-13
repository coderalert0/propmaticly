# frozen_string_literal: true

class Inspection < ApplicationRecord
  belongs_to :inspection_rule
  belongs_to :building
  has_many_attached :files

  scope :pending, -> { where(status: 'pending') }

  enum status: { pending: 0, completed: 1 }

  validates :inspection_rule_id, :building_id, :status, presence: true
end
