# frozen_string_literal: true

require 'faraday'

class FetchHpdViolationsJob < FetchJob
  private

  def url
    'https://data.cityofnewyork.us/resource/wvxf-dwi5.json'
  end

  def resource_where_params(violation, building)
    { hpd_number: violation['violationid'],
      building: building }
  end

  def resource_attributes(violation)
    {
      description: violation['novdescription']
    }
  end

  def normalize_address_params(violation)
    {
      address1: "#{violation['housenumber']&.strip} #{violation['streetname']&.strip} ##{violation['apartment']&.strip}",
      city: nil,
      state: nil,
      zip5: violation['zip']&.strip
    }
  end

  def resource_clazz
    Violation
  end
end
