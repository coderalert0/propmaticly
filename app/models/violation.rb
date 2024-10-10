# frozen_string_literal: true

class Violation < ApplicationRecord
  belongs_to :building
  after_commit :send_notification, on: :create

  private

  def send_notification
    ViolationNotifierJob.perform_later id
  end
end
