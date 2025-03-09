# frozen_string_literal: true

require 'faraday'

module Inspections
  class FetchElevatorInspectionsJob < FetchInspectionsJob
    private

    def url
      'https://data.cityofnewyork.us/resource/e5aq-a4j2.json'
    end

    def inspection_rule
      InspectionRule.find_by(compliance_item: :elevator)
    end

    def existing_record
      Inspection.find_by("data ->> 'device_number' = ? AND data ->> 'periodic_report_year' = ? AND building_id = ?",
                         @resource['device_number'], @resource['periodic_report_year'], @building.id)
    end

    def filtered_columns
      %i[device_number device_type device_status status_date equipment_type periodic_report_year
         cat1_report_year cat1_latest_report_filed cat5_latest_report_filed periodic_latest_inspection]
    end
  end
end
