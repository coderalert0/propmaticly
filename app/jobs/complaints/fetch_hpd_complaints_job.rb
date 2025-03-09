# frozen_string_literal: true

module Complaints
  class FetchHpdComplaintsJob < ::FetchComplaintsViolationsJob
    private

    def hpd_severity_enum(status)
      status == 'EMERGENCY' ? 1 : 0
    end

    def url
      'https://data.cityofnewyork.us/resource/ygpa-z7cr.json'
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

    def resource_clazz
      Complaints::HpdComplaint
    end
  end
end
