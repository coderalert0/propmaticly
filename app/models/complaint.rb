# frozen_string_literal: true

class Complaint < ApplicationRecord
  belongs_to :building
  # after_commit :send_notification, on: :create

  enum severity: {
    non_emergency: 0,
    emergency: 1,
    immediate_emergency: 2
  }

  enum state: {
    open: 0,
    in_progress: 1,
    closed: 2
  }

  scope :open, -> { where(state: 0) }
  scope :in_progress, -> { where(state: 1) }
  scope :closed, -> { where(state: 2) }

  private

  def send_notification
    ComplaintNotifierJob.perform_later id
  end
end
