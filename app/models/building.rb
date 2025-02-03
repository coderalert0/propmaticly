# frozen_string_literal: true

class Building < ApplicationRecord
  belongs_to :portfolio
  has_many :asset_contacts, as: :assignable, dependent: :destroy
  has_many :users, through: :asset_contacts
  has_many :complaints, dependent: :destroy
  has_many :violations, dependent: :destroy
  has_many :inspections, dependent: :destroy

  validates :name, :street, :city, :bin, :portfolio_id, presence: true
  after_commit :trigger_fetch_complaints_violations_jobs, on: %i[create update]

  def inspection_rules
    InspectionRule.all.select do |rule|
      rule_keys = rule.has_properties.select { |_, value| value == true }.keys
      has_properties_match = rule_keys.all? { |key| has_properties[key] == true }

      numerical_properties_match = rule.numerical_properties.all? do |key, condition|
        building_value = numerical_properties[key]
        building_value&.send(condition['operator'], condition['value'])
      end

      has_properties_match && numerical_properties_match
    end
  end

  private

  def trigger_fetch_complaints_violations_jobs
    return unless bin.present?

    FetchDobComplaintsJob.perform_later bin
    FetchDobEcbViolationsJob.perform_later bin
    FetchDobSafetyViolationsJob.perform_later bin
    FetchDobViolationsJob.perform_later bin
    FetchHpdComplaintsJob.perform_later bin
    FetchHpdViolationsJob.perform_later bin
  end
end
