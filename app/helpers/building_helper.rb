# frozen_string_literal: true

require 'faraday'

module BuildingHelper
  def self.update_bbl_bin(hash = {})
    response = Faraday.get('https://api.nyc.gov/geo/geoclient/v1/address.json', {
                             houseNumber: hash[:house_number],
                             street: hash[:street],
                             zip: hash[:zip]
                           }) do |req|
      req.headers['Ocp-Apim-Subscription-Key'] = 'f9a5da4b1e0b45a1bde0564c58f3aa64'
    end

    return unless response.status == 200
  end
end
