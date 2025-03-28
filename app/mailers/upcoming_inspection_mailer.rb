# frozen_string_literal: true

class UpcomingInspectionMailer < ApplicationMailer
  def notification(inspection, email)
    @inspection = inspection

    mail(
      to: email,
      subject: "#{@inspection.inspection_rule.decorate.compliance_item_humanize} inspection due on #{@inspection.due_date&.strftime('%D')}"
    )
  end
end
