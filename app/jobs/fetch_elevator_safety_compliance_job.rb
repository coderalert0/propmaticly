# frozen_string_literal: true

require 'faraday'

class FetchElevatorSafetyComplianceJob < ApplicationJob
  def perform(bin_id = nil)
    bin_ids = where_bin_ids(bin_id)
    query_string = { '$where' => "bin IN (#{bin_ids.map { |bin| "'#{bin}'" }.join(', ')})" }

    response = Faraday.get('https://data.cityofnewyork.us/resource/e5aq-a4j2.json', query_string)
    return unless response.status == 200

    Building.where(bin: bin_ids)
    JSON.parse(response.body).each do |resource|
      puts resource
    end
  end

  private

  def where_bin_ids(bin_id = nil)
    bin_id ? [bin_id] : Building.all.pluck(:bin)
  end
end
