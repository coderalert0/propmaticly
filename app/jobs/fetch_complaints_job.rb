# frozen_string_literal: true

require 'faraday'

class FetchComplaintsJob < ApplicationJob
  def perform
    puts 'Fetching!'
    response = Faraday.get 'https://data.cityofnewyork.us/resource/eabe-havv.json?date_entered=08/05/2023'
    puts JSON.parse(response.body)[0]
    puts "Status => #{response.status}"
  end
end
