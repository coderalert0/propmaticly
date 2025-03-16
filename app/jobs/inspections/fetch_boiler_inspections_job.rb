# frozen_string_literal: true

require 'faraday'

module Inspections
  class FetchBoilerInspectionsJob < FetchInspectionsJob
    private

    def url
      'https://data.cityofnewyork.us/resource/52dp-yji6.json'
    end

    def inspection_rule
      compliance_item = @resource['pressure_type'].downcase.gsub(' ', '_') << '_boiler'
      InspectionRules::InspectionRule.find_by(compliance_item: compliance_item.to_sym)
    end

    def existing_record
      Inspection.find_by("data ->> 'tracking_number' = ? AND data ->> 'boiler_id' = ? AND data ->> 'report_type' = ? AND building_id = ? AND inspection_rule_id = ?",
                         @resource['tracking_number'], @resource['boiler_id'], @resource['report_type'], @building.id, inspection_rule)
    end

    def filtered_columns
      %i[tracking_number boiler_id report_type applicantfirst_name applicant_last_name
         applicant_license_type applicant_license_number boiler_make boiler_model pressure_type
         inspection_type inspection_date defects_exist lff_45_days lff_180_days filing_fee
         total_amount_paid report_status]
    end

    def query_string(bin_id)
      { '$where' => "bin_number = '#{bin_id}'" }
    end

    def filing_date
      Date.parse(@resource['inspection_date'])
    end
  end
end
