# frozen_string_literal: true

class FetchHpdComplaintsJob < FetchJob
  private

  def hpd_severity_enum(status)
    status == 'EMERGENCY' ? 1 : 0
  end

  def url
    'https://data.cityofnewyork.us/resource/ygpa-z7cr.json?house_number=2664&apartment=5A'
  end

  def resource_where_params(complaint, building)
    { complaint_id: complaint['complaint_id'], building: building }
  end

  def resource_update_attributes(complaint)
    {
      filed_date: complaint['received_date'],
      description: [
        ["LOCATION: #{complaint['space_type'].capitalize}", "CATEGORY: #{complaint['major_category'].capitalize}/#{complaint['minor_category'].capitalize}",
         "PROBLEM: #{complaint['problem_code'].capitalize}"].join(', '), complaint['status_description']
      ].join("\n\n"),
      state: resource_clazz.mapped_state(complaint['complaint_status']),
      severity: resource_clazz.mapped_severity(complaint['type'])
    }
  end

  def normalize_address_params(complaint)
    {
      address1: "#{complaint['house_number']&.strip}, #{complaint['street_name']&.strip}",
      city: nil,
      state: nil,
      zip5: complaint['post_code']&.strip
    }
  end

  def resource_clazz
    HpdComplaint
  end
end
