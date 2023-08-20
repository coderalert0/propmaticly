# frozen_string_literal: true

require 'usps'

module AddressHelper
  def self.normalize(address1, zip5)
    USPS.config.username = '1R59PROPM0741'
    address = USPS::Address.new(address1: address1, zip5: zip5)
    req = USPS::Request::AddressStandardization.new(address)

    response = req.send!
    response.get(address)
  end
end
