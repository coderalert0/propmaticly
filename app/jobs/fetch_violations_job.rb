# frozen_string_literal: true

require 'faraday'

class FetchViolationsJob < ApplicationJob
  def perform
    response = Faraday.get 'https://data.cityofnewyork.us/resource/3h2n-5cm9.json?issue_date=19880914'
    return unless response.status == 200

    JSON.parse(response.body).each do |violation|
      normalized_address = AddressHelper.normalize("#{violation['house_number']&.strip} #{violation['street']&.strip}",
                                                   I18n.t("boro.#{violation['boro']}")&.strip, 'NY', violation['zip']&.strip)

      next unless (buildings = Building.where(address1: normalized_address['address1'],
                                              zip5: normalized_address['zip5']))

      buildings.each do |building|
        Violation.find_or_initialize_by(number: violation['violation_number'], building: building)
                 .update(type_code: violation['violation_type_code'],
                         category: violation['violation_category'],
                         issue_date: Date.strptime(violation['issue_date'], '%m/%d/%Y'),
                         description: violation['description'],
                         disposition_date: violation['disposition_date'],
                         comments: violation['disposition_comments'])
      end
    end
  end
end
