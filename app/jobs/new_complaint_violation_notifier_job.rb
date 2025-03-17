# frozen_string_literal: true

class NewComplaintViolationNotifierJob < ApplicationJob
  def perform(resource_type, resource_id)
    resource = resource_type.constantize.find(resource_id)
    TwilioClient.new.send_sms(User.last,
                              "A new #{resource_type.demodulize.titleize} was filed for #{resource.building.name}, click link for details: ")
  end
end
