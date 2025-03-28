# frozen_string_literal: true

class ComplaintViolationMailer < ApplicationMailer
  def notification(resource, email)
    @resource = resource
    mail(
      to: email,
      subject: "New #{resource.class.name.demodulize.titleize} filed for #{resource.building.name}"
    )
  end
end
