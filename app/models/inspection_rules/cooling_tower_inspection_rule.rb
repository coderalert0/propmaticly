# frozen_string_literal: true

module InspectionRules
  class CoolingTowerInspectionRule < InspectionRule
    def self.highlighted_attributes
      %i[system_id status active_equip inspection_type inspection_date violation_code violation_type law_section]
    end
  end
end
