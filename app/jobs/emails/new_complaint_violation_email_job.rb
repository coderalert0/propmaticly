# frozen_string_literal: true

module Emails
  class NewComplaintViolationEmailJob < ApplicationJob
    def perform(resource_type, resource_id, email)
      resource = resource_type.constantize.find(resource_id)
      ComplaintViolationMailer.notification(resource, email).deliver_later
    rescue StandardError => e
      Rails.logger.error "Failed to send new complaint/violation email for resource type: #{resource_id}, resource id: #{resource_type}, email: #{email}, error: #{e.message}"
    end
  end
end
