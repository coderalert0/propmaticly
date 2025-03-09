# frozen_string_literal: true

class Inspection < ApplicationRecord
  belongs_to :inspection_rule
  belongs_to :building
  has_many_attached :files

  validates :inspection_rule_id, :building_id, presence: true
end
