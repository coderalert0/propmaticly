# frozen_string_literal: true

require 'faraday'

class FetchComplaintsJob < ApplicationJob
  def perform
    # response = Faraday.get "https://data.cityofnewyork.us/resource/eabe-havv.json?date_entered=#{Time.now.strftime("%D")}"
    response = Faraday.get 'https://data.cityofnewyork.us/resource/eabe-havv.json?date_entered=08/01/2023'
    return unless response.status == 200

    JSON.parse(response.body).each do |complaint|
      binding.break
      next unless complaint['house_number']
      next unless complaint['house_street']
      next unless complaint['zip_code']

      normalized_address = AddressHelper.normalize(
        "#{complaint['house_number']&.strip} #{complaint['house_street']&.strip}", complaint['zip_code']&.strip
      )

      next unless (building = Building.find_by(address1: normalized_address['address1'],
                                               zip5: normalized_address['zip5']))

      Complaint.find_or_initialize_by(complaint_id: complaint['complaint_number'])
               .update(building_id: building.id,
                       filed_date: Date.strptime(complaint['date_entered'], '%m/%d/%Y'),
                       disposition_date: Date.strptime(complaint['disposition_date'], '%m/%d/%Y'),
                       category: complaint['complaint_category'],
                       last_inspection_date: Date.strptime(complaint['date_entered'], '%m/%d/%Y'),
                       last_inspection_result: complaint['disposition_code'].to_sym,
                       state: state_enum(complaint['status']),
                       building: building)
    end
  end

  private

  def state_enum(status)
    status == 'ACTIVE' ? 0 : 2
  end
end
