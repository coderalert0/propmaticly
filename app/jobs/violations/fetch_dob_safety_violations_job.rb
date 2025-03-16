# frozen_string_literal: true

module Violations
  class FetchDobSafetyViolationsJob < ::FetchComplaintsViolationsJob
    private

    def url
      'https://data.cityofnewyork.us/resource/855j-jady.json'
    end

    def resource_where_params
      { violation_id: @resource['violation_number'], building: @building }
    end

    def resource_update_attributes
      {
        issue_date: @resource['violation_issue_date'],
        violation_type: @resource['violation_type'],
        description: @resource['violation_remarks'],
        device_number: @resource['device_number'],
        device_type: @resource['device_type']
      }
    end

    def resource_clazz
      Violations::DobSafetyViolation
    end

    def state
      resource_clazz.mapped_state(@resource['violation_status'])
    end
  end
end
