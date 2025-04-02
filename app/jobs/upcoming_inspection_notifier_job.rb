# frozen_string_literal: true

class UpcomingInspectionNotifierJob < ApplicationJob
  def perform(inspection_id)
    inspection = Inspection.find(inspection_id)
    building = inspection.building

    building.users.each do |user|
      if user.sms.present?
        ActiveRecord::Base.transaction do
          SmsJob.perform_later(user.sms,
                               "Propmaticly: The #{inspection.inspection_rule.decorate.compliance_item_humanize} Inspection for #{building.name} is due on #{inspection.due_date&.strftime('%D')}, login for details")
          # ideally it should track the inspection/user pair that were notified
          inspection.update(notified: true)
        end
      end

      ActiveRecord::Base.transaction do
        Emails::UpcomingInspectionEmailJob.perform_later(inspection_id, user.email)
        inspection.update(notified: true)
      end
    end
  rescue StandardError => e
    Rails.logger.error "Failed to send upcoming inspection notification for id: #{inspection.id}, error: #{e.message}"
  end
end
