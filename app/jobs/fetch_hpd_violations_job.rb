# frozen_string_literal: true

class FetchHpdViolationsJob < FetchJob
  private

  def url
    'https://data.cityofnewyork.us/resource/wvxf-dwi5.json?violationid=10000824'
  end

  def resource_where_params(violation, building)
    { violation_id: violation['violationid'], building: building }
  end

  def resource_update_attributes(violation)
    {
      description: violation['novdescription'],
      issue_date: violation['novissueddate'],
      state: resource_clazz.mapped_state(violation['violationstatus'])
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
    HpdViolation
  end
end
