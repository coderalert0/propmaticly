# frozen_string_literal: true

require 'faraday'

class FetchDobEcbViolationsJob < FetchJob
  private

  def url
    'https://data.cityofnewyork.us/resource/6bgk-3dad.json'
  end

  def building_where_params(violation, building)
    { dob_number: violation['dob_violation_number'],
      ecb_number: violation['ecb_violation_number'],
      building: building }
  end

  def resource_attributes(violation)
    {
      description: violation['violation_description']
    }
  end

  def normalize_address_params(violation)
    {
      address1: "#{violation['respondent_house_number']&.strip} #{violation['respondent_street']&.strip}",
      city: I18n.t("boro.#{violation['boro']}")&.strip,
      state: 'NY',
      zip5: violation['respondent_zip']&.strip
    }
  end

  def resource_clazz
    Violation
  end
end
