# frozen_string_literal: true

require 'faraday'

module Inspections
  class FetchFacadeInspectionsJob < FetchInspectionsJob
    private

    def url
      'https://data.cityofnewyork.us/resource/xubg-57si.json'
    end

    def inspection_rule
      InspectionRules::InspectionRule.find_by(compliance_item: :facade)
    end

    def existing_record
      Inspection.find_by("data ->> 'tr6_no' = ? AND data ->> 'control_no' = ? AND data ->> 'filing_type' = ? AND building_id = ? AND inspection_rule_id = ?",
                         @resource['tr6_no'], @resource['control_no'], @resource['filing_type'], @building.id, inspection_rule)
    end

    def filtered_columns
      %i[tr6_no control_no filing_type cycle sequence_no submitted_on current_status qewi_name
         qewi_bus_name qewi_nys_lic_no filing_date filing_status field_inspection_completed_date
         qewi_signed_date late_filing_amt failure_to_file_amt failure_to_collect_amt comments]
    end

    def filing_date
      Date.parse(@resource['filing_date'])
    end
  end
end
