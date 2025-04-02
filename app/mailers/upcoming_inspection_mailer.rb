# frozen_string_literal: true

class UpcomingInspectionMailer < ApplicationMailer
  def notification(inspection, email)
    @inspection = inspection
    @url = building_upcoming_inspections_url(@inspection.building, state: 'open')

    mail(
      to: email,
      subject: "#{@inspection.inspection_rule.decorate.compliance_item_humanize} inspection due on #{@inspection.due_date&.strftime('%D')}"
    )
  end
end
