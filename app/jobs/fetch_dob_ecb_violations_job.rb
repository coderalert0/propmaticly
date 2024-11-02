# frozen_string_literal: true

class FetchDobEcbViolationsJob < FetchJob
  private

  def url
    'https://data.cityofnewyork.us/resource/6bgk-3dad.json?bin=3148711'
  end

  def resource_where_params(violation, building)
    { violation_id: violation['ecb_violation_number'], building: building }
  end

  def resource_update_attributes(violation)
    {
      issue_date: violation['issue_date'],
      severity: resource_clazz.mapped_severity(violation['severity']),
      violation_type: violation['violation_type'],
      description: violation['violation_description'],
      state: resource_clazz.mapped_state(violation['ecb_violation_status'])
    }
  end

  def normalize_address_params(violation)
    {
      number: violation['respondent_house_number']&.strip,
      street: violation['respondent_street']&.strip,
      city: I18n.t("boro.#{violation['boro']}")&.strip,
      state: 'NY',
      zip5: violation['respondent_zip']&.strip
    }
  end

  def resource_clazz
    DobEcbViolation
  end
end
