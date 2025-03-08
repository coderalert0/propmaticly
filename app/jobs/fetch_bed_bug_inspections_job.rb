# frozen_string_literal: true

require 'faraday'

class FetchBedBugInspectionsJob < FetchInspectionsJob
  private

  def url
    'https://data.cityofnewyork.us/resource/wz6d-d3jb.json'
  end

  def model_clazz
    BedBugInspection
  end

  def inspection_rule
    InspectionRule.find_by(compliance_item: :bed_bug)
  end

  def existing_record
    model_clazz.find_by(registration_id: @resource['registration_id'],
                        filing_date: @resource['filing_date'],
                        building_id: @building.id)
  end
end
