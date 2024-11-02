# frozen_string_literal: true

require 'faraday'

class FetchJob < ApplicationJob
  def perform
    response = Faraday.get(url, { '$where' => "bin IN (#{where_bin_ids.map { |bin| "'#{bin}'" }.join(', ')})" })

    return unless response.status == 200

    JSON.parse(response.body).each do |resource|
      next unless (buildings = Building.where(bin: where_bin_ids))

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

  def where_bin_ids
    Building.all.pluck(:bin)
  end
end
