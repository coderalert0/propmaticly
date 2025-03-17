# frozen_string_literal: true

class NewComplaintViolationNotifierJob < ApplicationJob
  def perform(resource_type, resource_id)
    resource = resource_type.constantize.find(resource_id)
    resource.building.users.pluck(:sms).compact.each do |user|
      TwilioClient.new.send_sms(user.sms,
                                "A new #{resource_type.demodulize.titleize} was filed for #{resource.building.name}, click link for details: ")
    end
  rescue StandardError => e
    Rails.logger.error "Failed to send new complaint/violation notification for id: #{resource.id}, type: #{resource_type}, error: #{e.message}"
  end
end
