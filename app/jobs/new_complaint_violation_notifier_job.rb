# frozen_string_literal: true

class NewComplaintViolationNotifierJob < ApplicationJob
  def perform(resource_type, resource_id)
    resource = resource_type.constantize.find(resource_id)
    building = resource.building

    building.users.each do |user|
      if user.sms.present?
        SnsClient.new.send_sms(user.sms,
                               "A new #{resource_type.demodulize.titleize} was filed for #{resource.building.name}, click link for details: ")
      end

      NewComplaintViolationEmailJob.perform_later(resource_type, resource_id, user.id)
    end
  rescue StandardError => e
    Rails.logger.error "Failed to send new complaint/violation notification for id: #{resource.id}, type: #{resource_type}, error: #{e.message}"
  end
end
