# frozen_string_literal: true

require 'faraday'

class FetchViolationsJob < ApplicationJob
  def perform
    response = Faraday.get 'https://data.cityofnewyork.us/resource/6bgk-3dad.json?issue_date=19880914'
    return unless response.status == 200

    JSON.parse(response.body).each do |violation|
      next unless violation['respondent_house_number']
      next unless violation['respondent_street']
      next unless violation['respondent_zip']

      violation_address = AddressHelper.normalize(
        "#{violation['respondent_house_number'].strip} #{violation['respondent_street'].strip}",
        violation['respondent_zip'].strip
      )

      next unless (building = Building.find_by(address1: violation_address['address1'],
                                               zip5: violation_address['zip5']))

      Violation.find_or_initialize_by(number: violation['violation_number'])
               .update(building_id: building.id,
                       type_code: violation['violation_type_code'],
                       description: violation['description'],
                       comments: violation['comments'],
                       issue_date: Date.strptime(violation['issue_date'], '%m/%d/%Y'),
                       disposition_date: violation['disposition_date'],
                       building: building)
    end
  end
end
