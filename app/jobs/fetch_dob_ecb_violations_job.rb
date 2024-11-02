# frozen_string_literal: true

class FetchDobEcbViolationsJob < FetchJob
  private

  def url
    'https://data.cityofnewyork.us/resource/6bgk-3dad.json'
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

  def resource_clazz
    DobEcbViolation
  end
end
