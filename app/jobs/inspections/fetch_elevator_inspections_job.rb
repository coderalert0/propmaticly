# frozen_string_literal: true

require 'faraday'

module Inspections
  class FetchElevatorInspectionsJob < FetchInspectionsJob
    INSPECTION_TYPES = {
      cat1_latest_report_filed: :elevator_cat_1,
      cat5_latest_report_filed: :elevator_cat_5,
      periodic_latest_inspection: :elevator_periodic
    }.freeze

    private

    def url
      'https://data.cityofnewyork.us/resource/e5aq-a4j2.json'
    end

    def inspection_rule
      InspectionRules::InspectionRule.find_by(compliance_item: :elevator)
    end

    def existing_record
      Inspection.find_by("data ->> 'device_number' = ? AND data ->> 'periodic_report_year' = ? AND building_id = ? AND inspection_rule_id = ?",
                         @resource[:device_number], @resource[:periodic_report_year], @building.id, @inspection_rule.id)
    end

    def filtered_columns
      %i[device_number device_type device_status equipment_type periodic_report_year]
    end

    def process_resources
      JSON.parse(@response.body).each do |resource|
        @resource = resource.transform_keys(&:to_sym)
        INSPECTION_TYPES.each do |report_field, compliance_item|
          @inspection_rule = InspectionRules::InspectionRule.find_by(compliance_item: compliance_item)
          next unless @inspection_rule

          inspection_date = DateTime.parse(@resource[report_field])
          inspection_params = @resource.transform_keys(&:to_sym).slice(*filtered_columns)
          inspection_params.merge!(filing_date: inspection_date)

          if existing_record
            existing_record.update!(data: inspection_params)
            Rails.logger.info "Updated existing inspection record: #{existing_record.id}"
          else
            Inspection.create!(
              data: inspection_params,
              building_id: @building.id,
              inspection_rule_id: @inspection_rule.id,
              filing_date: inspection_date
            )
            Rails.logger.info "Created new inspection for #{report_field}: #{inspection_params}"
          end
        rescue StandardError => e
          Rails.logger.error "Failed to process inspection record: #{e.message}, resource: #{@resource}"
          next
        end
      end
    end
  end
end
