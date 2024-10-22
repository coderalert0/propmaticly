# frozen_string_literal: true

class Violation < ApplicationRecord
  belongs_to :building
  after_commit :send_notification, on: :create

  enum severity: {
    non_hazardous: 0,
    hazardous: 1,
    immediately_hazardous: 2
  }

  enum state: {
    open: 0,
    in_progress: 1,
    closed: 2
  }

  private

  def send_notification
    ViolationNotifierJob.perform_later id
  end
end
