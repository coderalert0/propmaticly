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

    def resource_where_params
      { problem_id: @resource['problem_id'], complaint_id: @resource['complaint_id'], building: @building }
    end

    def resource_update_attributes
      {
        filed_date: @resource['received_date'],
        description: [
          ["LOCATION: #{@resource['space_type']&.capitalize}", "CATEGORY: #{@resource['major_category']&.capitalize}/#{@resource['minor_category']&.capitalize}",
           "PROBLEM: #{@resource['problem_code']&.capitalize}"].join(', '), @resource['status_description']
        ].join("\n\n"),
        severity: resource_clazz.mapped_severity(@resource['type'])
      }
    end

    def resource_clazz
      Complaints::HpdComplaint
    end

    def state
      resource_clazz.mapped_state(@resource['complaint_status'])
    end
  end
end
