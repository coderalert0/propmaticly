# frozen_string_literal: true

class UpcomingInspectionNotifierJob < ApplicationJob
  def perform(inspection_id)
    inspection = Inspection.find(inspection_id)
    inspection.building.users.pluck(:sms).compact.each do |user|
      ActiveRecord::Base.transaction do
        SnsClient.new.send_sms(user.sms,
                               "The #{inspection.inspection_rule.decorate.compliance_item_humanize} Inspection for #{inspection.building.name} is due on #{inspection.due_date} ")
        # ideally it should track the inspection/user pair that were notified
        inspection.update(notified: true)
      end
    end
  rescue StandardError => e
    Rails.logger.error "Failed to send upcoming inspection notification for id: #{inspection.id}, error: #{e.message}"
  end
end
