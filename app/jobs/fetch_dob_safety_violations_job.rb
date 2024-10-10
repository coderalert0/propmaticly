# frozen_string_literal: true

class FetchDobSafetyViolationsJob < FetchJob
  private

  def url
    'https://data.cityofnewyork.us/resource/855j-jady.json?bin=2056302'
  end

  def resource_where_params(violation, building)
    { violation_id: violation['violation_number'], building: building }
  end

  def resource_update_attributes(violation)
    {
      issue_date: violation['violation_issue_date'],
      violation_type: violation['violation_type'],
      state: violation['violation_status'],
      description: violation['violation_remarks'],
      device_number: violation['device_number'],
      device_type: violation['device_type']
    }
  end

  def normalize_address_params(violation)
    {
      address1: "#{violation['house_number']&.strip} #{violation['street']&.strip}",
      city: violation['city']&.strip,
      state: nil,
      zip5: violation['zip']&.strip
    }
  end

  def resource_clazz
    DobSafetyViolation
  end
end
