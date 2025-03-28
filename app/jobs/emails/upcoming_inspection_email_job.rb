# frozen_string_literal: true

module Emails
  class UpcomingInspectionEmailJob < ApplicationJob
    def perform(inspection_id, email)
      inspection = Inspection.find(inspection_id)

      UpcomingInspectionMailer.notification(inspection, email).deliver_later
    rescue StandardError => e
      Rails.logger.error "Failed to send upcoming inspection email for inspection id: #{inspection_id}, email: #{email}, error: #{e.message}"
    end
  end
end
