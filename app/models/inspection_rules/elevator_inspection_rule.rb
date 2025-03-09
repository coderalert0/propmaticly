# frozen_string_literal: true

module InspectionRules
  class ElevatorInspectionRule < InspectionRule
    def self.highlighted_attributes
      %i[device_number device_type device_status status_date equipment_type periodic_report_year
         cat1_report_year cat1_latest_report_filed cat5_latest_report_filed periodic_latest_inspection]
    end
  end
end
