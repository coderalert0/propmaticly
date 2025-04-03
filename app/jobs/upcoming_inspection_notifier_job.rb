# frozen_string_literal: true

class UpcomingInspectionNotifierJob < ApplicationJob
  def perform(inspection_id)
    inspection = Inspection.find(inspection_id)
    building = inspection.building

    building.users.each do |user|
      next if Notification.exists?(user: user, notifiable: inspection)

      ActiveRecord::Base.transaction do
        if user.sms.present?
          SmsJob.perform_later(user.sms,
                               "Propmaticly: The #{inspection.inspection_rule.decorate.compliance_item_humanize} Inspection for #{building.name} is due on #{inspection.due_date&.strftime('%D')}, login for details")
        end

        Emails::UpcomingInspectionEmailJob.perform_later(inspection_id, user.email)
        Notification.create!(user: user, notifiable: inspection)
      end
    end
  rescue StandardError => e
    Rails.logger.error "Failed to send upcoming inspection notification for id: #{inspection.id}, error: #{e.message}"
  end
end
