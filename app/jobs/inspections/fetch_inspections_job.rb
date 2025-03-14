# frozen_string_literal: true

require 'faraday'

module Inspections
  class FetchInspectionsJob < ApplicationJob
    def perform(bin_id = nil)
      if bin_id.nil?
        Building.all.each { |building| create_or_update_inspection(building.bin) }
      else
        create_or_update_inspection(bin_id)
      end
    end

    def create_or_update_inspection(bin_id)
      @response = Faraday.get(url, query_string(bin_id))
      return unless @response.status == 200

      @building = Building.find_by(bin: bin_id)
      process_resources
    end

    def process_resources
      JSON.parse(@response.body).each do |resource|
        @resource = resource

        begin
          inspection_params = @resource.transform_keys(&:to_sym).slice(*filtered_columns)

          if existing_record
            existing_record.update!(data: inspection_params)
            Rails.logger.info "Updated existing inspection record: #{existing_record.id}"
          else
            Inspection.create!(data: inspection_params, building_id: @building.id,
                               inspection_rule_id: inspection_rule.id)
            Rails.logger.info "Created new inspection: #{inspection_params}"
          end
        rescue StandardError => e
          Rails.logger.error "Failed to create inspection record: #{e.message}, resource: #{@resource}"
          next
        end
      end
    end

    def query_string(bin_id)
      { '$where' => "bin = '#{bin_id}'" }
    end
  end
end
