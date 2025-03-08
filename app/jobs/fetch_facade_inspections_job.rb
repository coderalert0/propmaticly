# frozen_string_literal: true

require 'faraday'

class FetchFacadeInspectionsJob < FetchInspectionsJob
  private

  def url
    'https://data.cityofnewyork.us/resource/xubg-57si.json'
  end

  def model_clazz
    FacadeInspection
  end

  def inspection_rule
    InspectionRule.find_by(compliance_item: :facade)
  end

  def existing_record
    model_clazz.find_by(tr6_no: @resource['tr6_no'],
                        control_no: @resource['control_no'],
                        filing_type: @resource['filing_type'],
                        building_id: @building.id)
  end
end
