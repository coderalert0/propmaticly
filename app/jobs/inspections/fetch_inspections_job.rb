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
      @model_attributes = model_clazz.column_names.map(&:to_sym)

      JSON.parse(response.body).each do |resource|
        @resource = resource

        begin
          if existing_record
            existing_record.update!(inspection_params)
            Rails.logger.info "Updated existing #{model_clazz} record: #{existing_record.id}"
          else
            model_clazz.create!(inspection_params)
            Rails.logger.info "Created new #{model_clazz}: #{inspection_params}"
          end
        rescue StandardError => e
          Rails.logger.error "Failed to create #{model_clazz} record: #{e.message}, resource: #{@resource}"
          next
        end
      end
    end

    def query_string
      { '$where' => "bin = '#{@bin_id}'" }
    end

    def inspection_params
      attribute_params = @resource.transform_keys(&:to_sym).slice(*@model_attributes)
      attribute_params.merge!(building_id: @building.id, inspection_rule_id: inspection_rule.id)
    end
  end
end
