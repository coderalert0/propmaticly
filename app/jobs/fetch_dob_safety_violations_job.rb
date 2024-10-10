# frozen_string_literal: true

require 'faraday'

class FetchDobSafetyViolationsJob < FetchJob
  private

  def url
    'https://data.cityofnewyork.us/resource/855j-jady.json'
  end

  def building_where_params(violation, building)
    { dob_number: violation['violation_number'],
      building: building }
  end

  def resource_attributes(violation)
    {
      description: violation['violation_remarks']
    }
  end

  def normalize_address_params(violation)
    {
      address1: "#{violation['house_number']&.strip} #{violation['street']&.strip}",
      city: violation['city']&.strip,
      state: 'NY',
      zip5: violation['zip']&.strip
    }
  end

  def resource_clazz
    Violation
  end
end
