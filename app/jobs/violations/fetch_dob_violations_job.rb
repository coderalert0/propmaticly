# frozen_string_literal: true

module Violations
  class FetchDobViolationsJob < ::FetchComplaintsViolationsJob
    private

    def url
      'https://data.cityofnewyork.us/resource/3h2n-5cm9.json'
    end

    def resource_where_params(violation, building)
      { violation_id: violation['number'], building: building }
    end

    def resource_update_attributes(violation)
      {
        issue_date: violation['issue_date'],
        violation_type: violation['violation_type_code'],
        device_number: violation['device_number'],
        description: violation['description'],
        state: violation['number'].include?('*') ? :closed : :open
      }
    end

    def resource_clazz
      Violations::Violation
    end
  end
end
