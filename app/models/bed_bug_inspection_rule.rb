# frozen_string_literal: true

class BedBugInspectionRule < InspectionRule
  def self.highlighted_attributes
    %i[registration_id of_dwelling_units infested_dwelling_unit_count eradicated_unit_count re_infested_dwelling_unit
       filing_date]
  end
end
