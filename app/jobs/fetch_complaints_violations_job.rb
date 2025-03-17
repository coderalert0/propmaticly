# frozen_string_literal: true

require 'faraday'

class FetchComplaintsViolationsJob < ApplicationJob
  def perform(bin_id = nil, notify = false)
    @notify = notify

    bin_ids = bin_id ? [bin_id] : Building.all.pluck(:bin)
    bin_ids.each { |bin_id| create_or_update_complaints_violations(bin_id) }
  end

  def create_or_update_complaints_violations(bin_id)
    response = Faraday.get(url, { '$where' => "bin = '#{bin_id}'", '$limit' => 10_000 })
    return unless response.status == 200

    @building = Building.find_by(bin: bin_id)

    JSON.parse(response.body).each do |resource|
      @resource = resource
      find_or_initialize_and_update
    end
  end

  private

  def find_or_initialize_and_update
    resource_unique_params = resource_where_params
    resource_attributes = resource_update_attributes

    resource = resource_clazz.find_or_initialize_by(resource_unique_params) do |new_resource|
      new_resource.state = state
    end

    return unless resource.new_record? && resource.update(resource_attributes)
    return unless resource.state == 'open' && @notify

    NewComplaintViolationNotifierJob.perform_later(resource.class.name, resource.id)
  end
end
