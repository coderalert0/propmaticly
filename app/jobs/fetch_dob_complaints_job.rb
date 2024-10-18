# frozen_string_literal: true

class FetchDobComplaintsJob < FetchJob
  private

  def url
    'https://data.cityofnewyork.us/resource/eabe-havv.json?date_entered=08/01/2023'
  end

  def resource_where_params(complaint, building)
    { complaint_id: complaint['complaint_number'], building: building }
  end

  def resource_update_attributes(complaint)
    { filed_date: (Date.strptime(complaint['date_entered'], '%m/%d/%Y') if complaint['date_entered']),
      disposition_date: (Date.strptime(complaint['disposition_date'], '%m/%d/%Y') if complaint['disposition_date']),
      disposition_code: complaint['disposition_code'],
      category_code: complaint['complaint_category'],
      inspection_date: (Date.strptime(complaint['inspection_date'], '%m/%d/%Y') if complaint['inspection_date']),
      state: resource_clazz.mapped_state(complaint['status']) }
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
    DobComplaint
  end
end
