# frozen_string_literal: true

require 'faraday'

class FetchComplaintsJob < ApplicationJob
  def perform
    puts 'Fetching!'
    # response = Faraday.get "https://data.cityofnewyork.us/resource/eabe-havv.json?date_entered=#{Time.now.strftime("%D")}"
    response = Faraday.get 'https://data.cityofnewyork.us/resource/eabe-havv.json?date_entered=08/01/2023'
    return unless response.status == 200

    JSON.parse(response.body).each do |complaint|
      complaint_address = AddressHelper.normalize(
        "#{complaint['house_number'].strip} #{complaint['house_street'].strip}", complaint['zip_code'].strip
      )

      next unless (building = Building.find_by(address1: complaint_address['address1'],
                                               zip5: complaint_address['zip5']))

      Complaint.find_or_initialize_by(complaint_id: complaint['complaint_number'])
               .update(building_id: building.id,
                       filed_date: Date.strptime(complaint['date_entered'], '%m/%d/%Y'),
                       category: complaint['complaint_category'],
                       last_inspection_date: complaint['inspection_date'],
                       last_inspection_result: complaint['disposition_code'].to_sym,
                       building: building)
    end
  end
end
