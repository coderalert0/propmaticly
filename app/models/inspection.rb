# frozen_string_literal: true

class Inspection < ApplicationRecord
  belongs_to :inspection_rule
  belongs_to :building

  validates :date, :inspection_rule_id, :building_id, presence: true

  enum device_status: {
    active: 0
  }
end
