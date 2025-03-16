# frozen_string_literal: true

module Violations
  class FetchHpdViolationsJob < ::FetchComplaintsViolationsJob
    private

    def url
      'https://data.cityofnewyork.us/resource/wvxf-dwi5.json'
    end

    def resource_where_params
      { violation_id: @resource['violationid'], building: @building }
    end

    def resource_update_attributes
      {
        description: @resource['novdescription'],
        issue_date: @resource['novissueddate']
      }
    end

    def resource_clazz
      Violations::HpdViolation
    end

    def state
      resource_clazz.mapped_state(@resource['violationstatus'])
    end
  end
end
