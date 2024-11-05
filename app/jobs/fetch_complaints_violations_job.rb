# frozen_string_literal: true

require 'faraday'

class FetchComplaintsViolationsJob < ApplicationJob
  def perform(bin_id = nil)
    bin_ids = where_bin_ids(bin_id)
    query_string = { '$where' => "bin IN (#{bin_ids.map { |bin| "'#{bin}'" }.join(', ')})" }

    response = Faraday.get(url, query_string)
    return unless response.status == 200

    buildings = Building.where(bin: bin_ids)
    JSON.parse(response.body).each do |resource|
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

  def where_bin_ids(bin_id = nil)
    bin_id ? [bin_id] : Building.all.pluck(:bin)
  end
end
