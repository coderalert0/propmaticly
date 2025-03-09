# frozen_string_literal: true

require 'faraday'

module Inspections
  class FetchCoolingTowerInspectionsJob < FetchInspectionsJob
    private

    def url
      'https://data.cityofnewyork.us/resource/f9wb-g8mb.json'
    end

    def model_clazz
      CoolingTowerInspection
    end

    def inspection_rule
      InspectionRule.find_by(compliance_item: :cooling_tower)
    end

    def existing_record
      model_clazz.find_by(system_id: @resource['system_id'],
                          inspection_date: @resource['inspection_date'],
                          inspection_type: @resource['inspection_type'],
                          building_id: @building.id)
    end
  end
end
