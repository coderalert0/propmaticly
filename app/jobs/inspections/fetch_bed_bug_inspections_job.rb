# frozen_string_literal: true

require 'faraday'

module Inspections
  class FetchBedBugInspectionsJob < FetchInspectionsJob
    private

    def url
      'https://data.cityofnewyork.us/resource/wz6d-d3jb.json'
    end

    def inspection_rule
      InspectionRules::InspectionRule.find_by(compliance_item: :bed_bug)
    end

    def existing_record
      Inspection.find_by("data ->> 'registration_id' = ? AND data ->> 'filing_date' = ? AND building_id = ?",
                         @resource['registration_id'], @resource['filing_date'], @building.id)
    end

    def filtered_columns
      %i[registration_id of_dwelling_units infested_dwelling_unit_count eradicated_unit_count
         re_infested_dwelling_unit filing_date filing_period_start_date filling_period_end_date]
    end
  end
end
