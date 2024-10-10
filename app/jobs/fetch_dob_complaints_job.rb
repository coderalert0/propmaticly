# frozen_string_literal: true

require 'faraday'

class FetchDobComplaintsJob < FetchJob
  private

  def state_enum(status)
    status == 'ACTIVE' ? 0 : 2
  end

  def url
    'https://data.cityofnewyork.us/resource/eabe-havv.json?date_entered=08/01/2023'
  end

  def building_where_params(complaint, building)
    { complaint_id: complaint['complaint_number'], building: building }
  end

  def resource_attributes(complaint)
    { filed_date: (Date.strptime(complaint['date_entered'], '%m/%d/%Y') if complaint['date_entered']),
      disposition_date: (Date.strptime(complaint['disposition_date'], '%m/%d/%Y') if complaint['disposition_date']),
      category: complaint['complaint_category'],
      last_inspection_date: (Date.strptime(complaint['inspection_date'], '%m/%d/%Y') if complaint['inspection_date']),
      last_inspection_result: complaint['disposition_code'].try(:to_sym),
      state: state_enum(complaint['status']) }
  end

  def normalize_address_params(complaint)
    {
      address1: "#{complaint['house_number']&.strip}, #{complaint['house_street']&.strip}",
      city: nil,
      state: nil,
      zip5: complaint['zip_code']&.strip
    }
  end

  def resource_clazz
    Complaint
  end
end
