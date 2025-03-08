# frozen_string_literal: true

require 'faraday'

class FetchBoilerInspectionsJob < FetchInspectionsJob
  private

  def url
    'https://data.cityofnewyork.us/resource/52dp-yji6.json'
  end

  def query_string
    { '$where' => "bin_number = '#{@bin_id}'" }
  end

  def model_clazz
    BoilerInspection
  end

  def inspection_rule
    compliance_item = @resource['pressure_type'].downcase.gsub(' ', '_') << '_boiler'
    InspectionRule.find_by(compliance_item: compliance_item.to_sym)
  end

  def existing_record
    model_clazz.find_by(tracking_number: @resource['tracking_number'],
                        boiler_id: @resource['boiler_id'],
                        report_type: @resource['report_type'],
                        building_id: @building.id)
  end
end
