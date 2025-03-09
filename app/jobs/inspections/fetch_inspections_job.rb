# frozen_string_literal: true

require 'faraday'

module Inspections
  class FetchInspectionsJob < ApplicationJob
    attr_accessor :bin_id

    def initialize(bin_id)
      @bin_id = bin_id
    end

    def perform
      response = Faraday.get(url, query_string)
      return unless response.status == 200

      @building = Building.find_by(bin: @bin_id)

      JSON.parse(response.body).each do |resource|
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

    def query_string
      { '$where' => "bin = '#{@bin_id}'" }
    end
  end
end
