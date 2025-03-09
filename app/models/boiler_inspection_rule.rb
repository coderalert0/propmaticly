# frozen_string_literal: true

class BoilerInspectionRule < InspectionRule
  def self.highlighted_attributes
    %i[boiler_id report_type boiler_make boiler_model pressure_type
       inspection_type inspection_date defects_exist report_status]
  end
end
