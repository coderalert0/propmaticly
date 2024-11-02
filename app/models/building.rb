# frozen_string_literal: true

class Building < ApplicationRecord
  belongs_to :portfolio
  has_many :asset_contacts, as: :assignable, dependent: :destroy
  has_many :users, through: :asset_contacts
  has_many :complaints, dependent: :destroy
  has_many :violations, dependent: :destroy

  validates_presence_of :name, :number, :street, :zip5
  after_commit :trigger_fetch_jobs, on: %i[create update]

  private

  def trigger_fetch_jobs
    return unless bin.present?

    FetchDobComplaintsJob.perform_later bin
    FetchDobEcbViolationsJob.perform_later bin
    FetchDobSafetyViolationsJob.perform_later bin
    FetchDobViolationsJob.perform_later bin
    FetchHpdComplaintsJob.perform_later bin
    FetchHpdViolationsJob.perform_later bin
  end
end
