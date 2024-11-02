# frozen_string_literal: true

class FetchDobViolationsJob < FetchJob
  private

  def url
    'https://data.cityofnewyork.us/resource/3h2n-5cm9.json?house_number=7509&street=3%20AVENUE'
  end

  def resource_where_params(violation, building)
    { violation_id: violation['number'], building: building }
  end

  def resource_update_attributes(violation)
    {
      issue_date: violation['issue_date'],
      violation_type: violation['violation_type_code'],
      device_number: violation['device_number'],
      description: violation['description']
    }
  end

  def normalize_address_params(violation)
    {
      number: violation['house_number']&.strip,
      street: violation['street']&.strip,
      city: I18n.t("boro.#{violation['boro']}")&.strip,
      state: 'NY',
      zip5: violation['zip']&.strip
    }
  end

  def resource_clazz
    Violation
  end
end
