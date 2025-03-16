# frozen_string_literal: true

module Violations
  class FetchDobSafetyViolationsJob < ::FetchComplaintsViolationsJob
    private

    def url
      'https://data.cityofnewyork.us/resource/855j-jady.json'
    end

    def resource_where_params(violation, building)
      { violation_id: violation['violation_number'], building: building }
    end

    def resource_update_attributes(violation)
      {
        issue_date: violation['violation_issue_date'],
        violation_type: violation['violation_type'],
        description: violation['violation_remarks'],
        device_number: violation['device_number'],
        device_type: violation['device_type']
      }
    end

    def resource_clazz
      Violations::DobSafetyViolation
    end

    def state
      resource_clazz.mapped_state(violation['violation_status'])
    end
  end
end
