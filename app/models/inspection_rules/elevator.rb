# frozen_string_literal: true

module InspectionRules
  class Elevator < InspectionRule
    def calculate_due_date_based_on_last_inspection
      # this is specific to elevators, may need to adapt in future for other inspections
      latest_filing_dates = Inspection.filed.where(inspection_rule_id: id,
                                                   building: @building).group("data->>'device_number'").maximum(:filing_date)
      latest_filing_dates.transform_values do |filing_date|
        filing_date + frequency_in_months.months
      end
    end
  end
end
