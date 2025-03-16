# frozen_string_literal: true

module Violations
  class FetchHpdViolationsJob < ::FetchComplaintsViolationsJob
    private

    def url
      'https://data.cityofnewyork.us/resource/wvxf-dwi5.json'
    end

    def resource_where_params(violation, building)
      { violation_id: violation['violationid'], building: building }
    end

    def resource_update_attributes(violation)
      {
        description: violation['novdescription'],
        issue_date: violation['novissueddate']
      }
    end

    def resource_clazz
      Violations::HpdViolation
    end

    def state
      resource_clazz.mapped_state(violation['violationstatus'])
    end
  end
end
