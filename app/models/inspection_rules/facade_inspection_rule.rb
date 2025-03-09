# frozen_string_literal: true

module InspectionRules
  class FacadeInspectionRule < InspectionRule
    def self.highlighted_attributes
      %i[tr6_no control_no filing_type cycle sequence_no
         submitted_on filing_date current_status filing_status]
    end
  end
end
