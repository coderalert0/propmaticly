# frozen_string_literal: true

module Violations
  class FetchDobEcbViolationsJob < ::FetchComplaintsViolationsJob
    private

    def url
      'https://data.cityofnewyork.us/resource/6bgk-3dad.json'
    end

    def resource_where_params
      { violation_id: @resource['ecb_violation_number'], building: @building }
    end

    def resource_update_attributes
      {
        issue_date: @resource['issue_date'],
        severity: resource_clazz.mapped_severity(@resource['severity']),
        violation_type: @resource['violation_type'],
        description: @resource['violation_description']
      }
    end

    def resource_clazz
      Violations::DobEcbViolation
    end

    def state
      resource_clazz.mapped_state(@resource['ecb_violation_status'])
    end
  end
end
