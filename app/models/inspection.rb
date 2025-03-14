# frozen_string_literal: true

class Inspection < ApplicationRecord
  belongs_to :inspection_rule, class_name: 'InspectionRules::InspectionRule'
  belongs_to :building
  has_many_attached :attachments

  audited

  scope :filed, -> { where.not(data: {}) }
  scope :upcoming, -> { where(data: {}) }
  scope :pending, -> { where(filing_date: nil) }
  scope :completed, -> { where.not(filing_date: nil) }
  scope :overdue, -> { where('due_date <= ?', Date.today) }

  validates :inspection_rule_id, :building_id, presence: true
end
