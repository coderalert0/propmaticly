# frozen_string_literal: true

class NewComplaintViolationNotifierJob < ApplicationJob
  def perform(resource_type, resource_id)
    resource = resource_type.constantize.find(resource_id)
    building = resource.building

    building.users.each do |user|
      ActiveRecord::Base.transaction do
        if user.sms.present?
          SmsJob.perform_later(user.sms,
                               "Propmaticly: A new #{resource_type.demodulize.titleize} was filed for #{resource.building.name}, login for details")
        end

        Emails::NewComplaintViolationEmailJob.perform_later(resource_type, resource_id, user.email)
      end
    end
  rescue StandardError => e
    Rails.logger.error "Failed to send new complaint/violation notification for id: #{resource.id}, type: #{resource_type}, error: #{e.message}"
  end
end
