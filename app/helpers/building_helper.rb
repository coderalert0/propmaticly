# frozen_string_literal: true

require 'faraday'

module BuildingHelper
  def self.get_building_details(number, street, zip)
    response = Faraday.get('https://api.nyc.gov/geo/geoclient/v1/address.json', {
                             houseNumber: number,
                             street: street,
                             zip: zip
                           }) do |req|
      req.headers['Ocp-Apim-Subscription-Key'] = 'f9a5da4b1e0b45a1bde0564c58f3aa64'
    end

    return unless response.status == 200

    result = JSON.parse(response.body)['address'].slice('bbl',
                                                        'buildingIdentificationNumber',
                                                        'communityDistrictBoroughCode',
                                                        'communityDistrictNumber',
                                                        'bblTaxBlock')

    result['bin'] = result.delete('buildingIdentificationNumber')
    result['community_district_borough_code'] = result.delete('communityDistrictBoroughCode')
    result['community_district_number'] = result.delete('communityDistrictNumber')
    result['tax_block_number'] = result.delete('bblTaxBlock')

    result
  rescue StandardError => e
    raise e
  end

  def self.create_upcoming_inspections(building: nil, start_date: Date.today, end_date: 1.year.from_now)
    buildings = building ? [building] : Building.all

    buildings.each do |current_building|
      current_building.inspection_rules.each do |rule|
        next_inspection_date = InspectionRuleHelper.calculate_fixed_due_date(rule, start_date)
        next unless next_inspection_date && next_inspection_date <= end_date

        current_building.inspections.find_or_create_by(
          inspection_rule: rule,
          due_date: next_inspection_date
        ) do |inspection|
          inspection.status = :pending
        end
      end
    end
  end
end
