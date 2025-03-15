# frozen_string_literal: true

class Inspection < ApplicationRecord
  belongs_to :inspection_rule, class_name: 'InspectionRules::InspectionRule'
  belongs_to :building
  has_many_attached :attachments

  audited

  scope :filed, -> { where.not(data: {}) }
  scope :internal, -> { where(data: {}) }
  scope :upcoming, -> { where(data: {}).and(where(filing_date: nil)) }
  scope :pending, -> { where(filing_date: nil) }
  scope :overdue, -> { where('due_date <= ?', Date.today) }
  scope :completed, -> { where.not(data: {}).or(where.not(filing_date: nil)) }

  validates :inspection_rule_id, :building_id, presence: true
end
