# frozen_string_literal: true

require 'faraday'

module AddressHelper
  def self.normalize(hash = {})
    return if hash[:number].nil? || hash[:street].nil?

    client_id = Rails.application.credentials.usps[:client_id]
    client_secret = Rails.application.credentials.usps[:client_secret]

    conn = Faraday.new(url: 'https://apis.usps.com') do |f|
      f.request :json
      f.response :json
    end

    response = conn.post('/oauth2/v3/token') do |req|
      req.headers['Content-Type'] = 'application/json'
      req.body = {
        client_id: client_id,
        client_secret: client_secret,
        grant_type: 'client_credentials'
      }.to_json
    end

    if response.success?
      token = response.body['access_token']

      response = conn.get('/addresses/v3/address') do |req|
        req.headers['Accept'] = 'application/json'
        req.headers['Authorization'] = "Bearer #{token}"
        req.params['streetAddress'] = "#{hash[:number]} #{hash[:street]}"
        req.params['city'] = hash[:city]
        req.params['state'] = hash[:state]
        req.params['ZIPCode'] = hash[:zip5]
      end

      return response.body['address'] if response.success?

      Rails.logger.error "Address API failed: #{response.status} - #{response.body}"

    else
      Rails.logger.error "Token request failed: #{response.status} - #{response.body}"
    end
  end
end
