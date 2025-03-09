# frozen_string_literal: true

module InspectionRules
  class InspectionRule < ApplicationRecord
    has_many :inspections, dependent: :destroy

    validates :compliance_item, :frequency_in_months, presence: true

    enum compliance_item: {
      backflow_prevention: 0,
      bed_bug: 1,
      high_pressure_boiler: 2,
      low_pressure_boiler: 3,
      cooling_tower: 4,
      elevator: 5,
      facade: 6,
      sprinkler_system: 7,
      standpipe_system: 8,
      window_guard: 9,
      energy_efficiency_ratings: 10,
      annual_property_registration: 11,
      parking_structure: 12,
      gas_line: 13,
      energy_efficiency_ll_87: 14,
      energy_benchmarking: 15,
      energy_efficiency_ll_133: 16
    }
  end
end
