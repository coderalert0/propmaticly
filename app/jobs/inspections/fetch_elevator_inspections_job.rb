# frozen_string_literal: true

require 'faraday'

module Inspections
  class FetchElevatorInspectionsJob < FetchInspectionsJob
    private

    def url
      'https://data.cityofnewyork.us/resource/e5aq-a4j2.json'
    end

    def model_clazz
      ElevatorInspection
    end

    def inspection_rule
      InspectionRule.find_by(compliance_item: :elevator)
    end

    def existing_record
      model_clazz.find_by(device_number: @resource['device_number'],
                          periodic_report_year: @resource['periodic_report_year'],
                          building_id: @building.id)
    end
  end
end
