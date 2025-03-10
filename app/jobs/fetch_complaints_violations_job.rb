# frozen_string_literal: true

require 'faraday'

class FetchComplaintsViolationsJob < ApplicationJob
  def perform(bin_id = nil)
    if bin_id.nil?
      Building.all.each { |building| create_or_update_complaints_violations(building.bin) }
    else
      create_or_update_complaints_violations(bin_id)
    end
  end

  def create_or_update_complaints_violations(bin_id)
    response = Faraday.get(url, { '$where' => "bin = '#{bin_id}'" })
    return unless response.status == 200

    building = Building.find_by(bin: bin_id)

    JSON.parse(response.body).each do |resource|
      find_or_initialize_and_update(resource, building)
    end
  end

  private

  def find_or_initialize_and_update(resource, building)
    resource_params = resource_where_params(resource, building)
    resource_attributes = resource_update_attributes(resource)
    resource_clazz.find_or_initialize_by(resource_params).update(resource_attributes)
  end
end
