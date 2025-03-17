# frozen_string_literal: true

require 'usps'

module AddressHelper
  def self.normalize(hash = {})
    return if hash[:number].nil? || hash[:street].nil?

    USPS.config.username = Rails.application.credentials.usps[:username]

    address = USPS::Address.new(address1: "#{hash[:number]} #{hash[:street]}", city: hash[:city], state: hash[:state],
                                zip5: hash[:zip5])
    req = USPS::Request::AddressStandardization.new(address)

    response = req.send!
    response.get(address)
  rescue StandardError => e
    raise e
  end
end
