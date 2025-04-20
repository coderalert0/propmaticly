# frozen_string_literal: true

require 'faraday'

class ElevatorInspectorMailer < ApplicationMailer
  def offer_email
    url = 'https://data.cityofnewyork.us/resource/t8hj-ruu2.json?license_type=ELEVATOR%20AGENCY%20/%20INSPECTOR&license_status=ACTIVE'
    response = Faraday.get(url)

    return unless response.success?

    records = JSON.parse(response.body)

    records.each do |record|
      first_name = record['first_name']
      email      = record['business_email']

      next unless first_name.to_s.strip != '' && email.to_s.strip != ''

      first_name = first_name.titleize
      email = email.downcase

      ElevatorInspectorMailer.send_email(first_name, email).deliver_later
      Rails.logger.info "Queued Elevator Inspector Offer email for #{first_name} <#{email}>"
    end
  end

  def send_email(first_name, to_email)
    @first_name = first_name
    mail(
      to: to_email,
      subject: 'Offer Your Clients Timely Elevator Alerts'
    )
  end
end
