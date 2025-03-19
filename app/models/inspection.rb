# frozen_string_literal: true

class Inspection < ApplicationRecord
  include Attachable

  belongs_to :inspection_rule, class_name: 'InspectionRules::InspectionRule'
  belongs_to :building
  has_many_attached :attachments, dependent: :destroy

  audited

  scope :external, -> { where.not(data: {}) }
  scope :internal, -> { where(data: {}) }
  scope :open, -> { where(state: :open) }
  scope :overdue, -> { where('due_date <= ?', Date.today) }
  scope :completed, -> { where.not(filing_date: nil) }

  validates :inspection_rule_id, :building_id, presence: true

  enum state: { open: 0, in_progress: 1, closed: 2 }
end
