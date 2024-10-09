# frozen_string_literal: true

require 'usps'

module AddressHelper
  def self.normalize(hash = {})
    return if hash[:address1].nil?

    USPS.config.username = '1R59PROPM0741'
    address = USPS::Address.new(address1: hash[:address1], city: hash[:city], state: hash[:state], zip5: hash[:zip5])
    req = USPS::Request::AddressStandardization.new(address)

    response = req.send!
    response.get(address)
  end
end
