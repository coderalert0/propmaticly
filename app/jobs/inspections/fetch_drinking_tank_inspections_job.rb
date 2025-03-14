# frozen_string_literal: true

require 'faraday'

module Inspections
  class FetchDrinkingTankInspectionsJob < FetchInspectionsJob
    private

    def url
      'https://data.cityofnewyork.us/resource/gjm4-k24g.json'
    end

    def inspection_rule
      InspectionRules::InspectionRule.find_by(compliance_item: :drinking_water_storage_tank)
    end

    def existing_record
      Inspection.find_by("data ->> 'confirmation_num' = ? AND data ->> 'inspection_date' = ? AND data ->> 'tank_num' = ? AND building_id = ? AND inspection_rule_id = ?",
                         @resource['confirmation_num'], @resource['inspection_date'], @resource['tank_num'], @building.id, inspection_rule)
    end

    def filtered_columns
      %i[confirmation_num reporting_year tank_num inspection_date sample_collected
         inspection_by_firm]
    end
  end
end
