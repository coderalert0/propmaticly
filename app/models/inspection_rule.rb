# frozen_string_literal: true

class InspectionRule < ApplicationRecord
  validates :compliance_item, :frequency_in_months, presence: true

  enum compliance_item: {
    backflow_prevention: 0,
    bed_bug: 1,
    boiler: 2,
    cooling_tower: 3,
    elevator: 4,
    facade: 5,
    sprinkler_system: 6,
    standpipe_system: 7,
    window_guard: 8,
    energy_efficiency_ratings: 9
  }
end
