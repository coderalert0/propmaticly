# frozen_string_literal: true

class Building < ApplicationRecord
  belongs_to :portfolio
  has_many :asset_contacts, as: :assignable, dependent: :destroy
  has_many :users, through: :asset_contacts
  has_many :complaints, class_name: 'Complaints::Complaint', dependent: :destroy
  has_many :violations, class_name: 'Violations::Violation', dependent: :destroy
  has_many :inspections, dependent: :destroy

  validates :name, :street, :city, :bin, :portfolio_id, presence: true

  after_commit :trigger_fetch_complaints_violations_jobs, on: %i[create update]
  after_commit :trigger_fetch_inspections_jobs, on: %i[create update]
  after_commit :trigger_create_upcoming_inspections_job, on: %i[create update]

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

    Complaints::FetchDobComplaintsJob.perform_later bin
    Complaints::FetchHpdComplaintsJob.perform_later bin

    Violations::FetchDobEcbViolationsJob.perform_later bin
    Violations::FetchDobSafetyViolationsJob.perform_later bin
    Violations::FetchDobViolationsJob.perform_later bin
    Violations::FetchHpdViolationsJob.perform_later bin
  end

  def trigger_fetch_inspections_jobs
    nil unless bin.present?

    Inspections::FetchBedBugInspectionsJob.perform_later bin
    Inspections::FetchBoilerInspectionsJob.perform_later bin
    Inspections::FetchCoolingTowerInspectionsJob.perform_later bin
    Inspections::FetchFacadeInspectionsJob.perform_later bin
    Inspections::FetchElevatorInspectionsJob.perform_later bin
  end

  def trigger_create_upcoming_inspections_job
    CreateUpcomingInspectionsJob.perform_later
  end
end
