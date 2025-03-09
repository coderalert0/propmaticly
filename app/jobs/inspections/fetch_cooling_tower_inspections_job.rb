# frozen_string_literal: true

require 'faraday'

module Inspections
  class FetchCoolingTowerInspectionsJob < FetchInspectionsJob
    private

    def url
      'https://data.cityofnewyork.us/resource/f9wb-g8mb.json'
    end

    def inspection_rule
      InspectionRules::InspectionRule.find_by(compliance_item: :cooling_tower)
    end

    def existing_record
      Inspection.find_by("data ->> 'system_id' = ? AND data ->> 'inspection_date' = ? AND data ->> 'inspection_type' = ? AND building_id = ?",
                         @resource['system_id'], @resource['inspection_date'], @resource['inspection_type'], @building.id)
    end

    def filtered_columns
      %i[system_id status active_equip inspection_date violation_code
         law_section violation_text violation_type citation_text summons_number
         inspection_type]
    end
  end
end
