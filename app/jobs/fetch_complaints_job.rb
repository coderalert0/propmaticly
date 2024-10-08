# frozen_string_literal: true

require 'faraday'

class FetchComplaintsJob < ApplicationJob
  def perform
    # response = Faraday.get "https://data.cityofnewyork.us/resource/eabe-havv.json?date_entered=#{Time.now.strftime("%D")}"
    response = Faraday.get 'https://data.cityofnewyork.us/resource/eabe-havv.json?date_entered=08/01/2023'
    return unless response.status == 200

    JSON.parse(response.body).each do |complaint|
      next unless complaint['zip_code']

      normalized_address = AddressHelper.normalize(
        "#{complaint['house_number']&.strip} #{complaint['house_street']&.strip}", nil, nil, complaint['zip_code']&.strip
      )

      next unless (buildings = Building.where(address1: normalized_address['address1'],
                                              zip5: normalized_address['zip5']))

      buildings.each do |building|
        Complaint.find_or_initialize_by(complaint_id: complaint['complaint_number'], building: building)
                 .update(filed_date: Date.strptime(complaint['date_entered'], '%m/%d/%Y'),
                         disposition_date: Date.strptime(complaint['disposition_date'], '%m/%d/%Y'),
                         category: complaint['complaint_category'],
                         last_inspection_date: Date.strptime(complaint['inspection_date'], '%m/%d/%Y'),
                         last_inspection_result: complaint['disposition_code'].to_sym,
                         state: state_enum(complaint['status']))
      end
    end
  end

  private

  def state_enum(status)
    status == 'ACTIVE' ? 0 : 2
  end
end
