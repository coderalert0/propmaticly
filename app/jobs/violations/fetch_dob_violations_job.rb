# frozen_string_literal: true

module Violations
  class FetchDobViolationsJob < ::FetchComplaintsViolationsJob
    private

    def url
      'https://data.cityofnewyork.us/resource/3h2n-5cm9.json'
    end

    def resource_where_params
      { violation_id: @resource['number'], building: @building }
    end

    def resource_update_attributes
      {
        issue_date: @resource['issue_date'],
        violation_type: @resource['violation_type_code'],
        device_number: @resource['device_number'],
        description: @resource['description']
      }
    end

    def resource_clazz
      Violations::Violation
    end

    def state
      @resource['number'].include?('*') ? :closed : :open
    end
  end
end
