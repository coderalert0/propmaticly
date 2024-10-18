# frozen_string_literal: true

require 'faraday'

class FetchJob < ApplicationJob
  def perform
    response = Faraday.get url
    return unless response.status == 200

    JSON.parse(response.body).each do |resource|
      begin
        normalize_address_params = normalize_address_params(resource)
        normalized_address = AddressHelper.normalize(normalize_address_params)
      rescue StandardError
        next
      end

      next unless (buildings = Building.where(address1: normalized_address['address1'],
                                              zip5: normalized_address['zip5']))

      buildings.each do |building|
        find_or_initialize_and_update(resource, building)
      end
    end
  end

  private

  def find_or_initialize_and_update(resource, building)
    resource_params = resource_where_params(resource, building)
    resource_attributes = resource_update_attributes(resource)
    resource_clazz.find_or_initialize_by(resource_params).update(resource_attributes)
  end
end
