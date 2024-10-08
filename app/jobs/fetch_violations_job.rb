# frozen_string_literal: true

require 'faraday'

class FetchViolationsJob < ApplicationJob
  def perform
    response = Faraday.get 'https://data.cityofnewyork.us/resource/3h2n-5cm9.json?issue_date=19880914'
    return unless response.status == 200

    JSON.parse(response.body).each do |violation|
      next unless violation['house_number']
      next unless violation['street']
      next unless violation['zip']

      violation_address = AddressHelper.normalize(
        "#{violation['house_number'].strip} #{violation['street'].strip}",
        violation['zip'].strip
      )

      next unless (building = Building.find_by(address1: violation_address['address1'],
                                               zip5: violation_address['zip5']))

      Violation.find_or_initialize_by(number: violation['violation_number'])
               .update(building_id: building.id,
                       type_code: violation['violation_type_code'],
                       category: violation['violation_category'],
                       issue_date: Date.strptime(violation['issue_date'], '%m/%d/%Y'),
                       description: violation['description'],
                       disposition_date: violation['disposition_date'],
                       comments: violation['disposition_comments'],
                       building: building)
    end
  end
end
