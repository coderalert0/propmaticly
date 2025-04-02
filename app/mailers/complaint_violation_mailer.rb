# frozen_string_literal: true

class ComplaintViolationMailer < ApplicationMailer
  def notification(resource, email)
    @resource = resource

    if resource.class.module_parent.to_s == 'Complaints'
      @url = building_complaints_url(resource.building, state: 'open')
      @resource_id = resource.complaint_id
    elsif resource.class.module_parent.to_s == 'Violations'
      @url = building_violations_url(resource.building, state: 'open')
      @resource_id = resource.violation_id
    end

    mail(
      to: email,
      subject: "New #{resource.class.name.demodulize.titleize} filed for #{resource.building.name}"
    )
  end
end
