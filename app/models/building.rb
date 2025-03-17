# frozen_string_literal: true

class Building < ApplicationRecord
  belongs_to :portfolio
  has_many :asset_contacts, as: :assignable, dependent: :destroy
  has_many :complaints, class_name: 'Complaints::Complaint', dependent: :destroy
  has_many :violations, class_name: 'Violations::Violation', dependent: :destroy
  has_many :inspections, dependent: :destroy

  validates :name, :street, :city, :bin, :portfolio_id, presence: true

  after_commit :trigger_fetch_complaints_violations_jobs, on: %i[create update]
  after_commit :trigger_fetch_inspections_jobs, on: %i[create update]

  def inspection_rules
    InspectionRules::InspectionRule.all.select do |rule|
      rule_keys = rule.has_properties.select { |_, value| value == true }.keys
      has_properties_match = rule_keys.all? { |key| has_properties[key] == true }

      numerical_properties_match = rule.numerical_properties.all? do |key, condition|
        building_value = numerical_properties[key]
        building_value&.send(condition['operator'], condition['value'])
      end

      has_properties_match && numerical_properties_match
    end
  end

  def users
    User.joins(:asset_contacts).where(asset_contacts: { assignable_type: 'Building', assignable_id: id })
        .or(User.joins(:asset_contacts).where(asset_contacts: { assignable_type: 'Portfolio',
                                                                assignable_id: portfolio_id }))
        .distinct
  end

  private

  def trigger_fetch_complaints_violations_jobs
    return unless bin.present?

    Complaints::FetchDobComplaintsJob.perform_later(bin_id: bin)
    Complaints::FetchHpdComplaintsJob.perform_later(bin_id: bin)

    Violations::FetchDobEcbViolationsJob.perform_later(bin_id: bin)
    Violations::FetchDobSafetyViolationsJob.perform_later(bin_id: bin)
    Violations::FetchDobViolationsJob.perform_later(bin_id: bin)
    Violations::FetchHpdViolationsJob.perform_later(bin_id: bin)
  end

  def trigger_fetch_inspections_jobs
    return unless bin.present?

    Inspections::FetchElevatorInspectionsJob.perform_later(bin_id: bin)
    Inspections::FetchBedBugInspectionsJob.perform_later(bin_id: bin)
    Inspections::FetchBoilerInspectionsJob.perform_later(bin_id: bin)
    Inspections::FetchCoolingTowerInspectionsJob.perform_later(bin_id: bin)
    Inspections::FetchFacadeInspectionsJob.perform_later(bin_id: bin)
    Inspections::FetchDrinkingTankInspectionsJob.perform_later(bin_id: bin)

    CreateUpcomingInspectionsJob.perform_later(building_id: self)
  end
end
