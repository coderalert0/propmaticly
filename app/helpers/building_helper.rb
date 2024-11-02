# frozen_string_literal: true

require 'faraday'

module BuildingHelper
  def self.get_bbl_bin(number, street, zip)
    response = Faraday.get('https://api.nyc.gov/geo/geoclient/v1/address.json', {
                             houseNumber: number,
                             street: street,
                             zip: zip
                           }) do |req|
      req.headers['Ocp-Apim-Subscription-Key'] = 'f9a5da4b1e0b45a1bde0564c58f3aa64'
    end

    return unless response.status == 200

    result = JSON.parse(response.body)['address'].slice('bbl', 'buildingIdentificationNumber')
    result['bin'] = result.delete('buildingIdentificationNumber')
    result
  rescue StandardError => e
    raise e
  end
end
