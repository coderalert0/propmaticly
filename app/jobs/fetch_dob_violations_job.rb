# frozen_string_literal: true

require 'faraday'

class FetchDobViolationsJob < FetchJob
  private

  def url
    'https://data.cityofnewyork.us/resource/3h2n-5cm9.json?issue_date=19880914'
  end

  def building_where_params(violation, building)
    { number: violation['dob_violation_number'], building: building }
  end

  def resource_attributes(violation)
    { type_code: violation['violation_type_code'],
      category: violation['violation_category'],
      issue_date: violation['issue_date'],
      description: violation['description'],
      disposition_date: violation['disposition_date'],
      comments: violation['disposition_comments'] }
  end

  def normalize_address_params(violation)
    {
      address1: "#{violation['house_number']&.strip} #{violation['street']&.strip}",
      city: I18n.t("boro.#{violation['boro']}")&.strip,
      state: 'NY',
      zip5: violation['zip']&.strip
    }
  end

  def resource_clazz
    Violation
  end
end
