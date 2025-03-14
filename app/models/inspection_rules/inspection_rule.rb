# frozen_string_literal: true

module InspectionRules
  class InspectionRule < ApplicationRecord
    has_many :inspections, dependent: :destroy

    validates :compliance_item, :frequency_in_months, presence: true

    enum :compliance_item, {
      backflow_prevention: 0,
      bed_bug: 1,
      high_pressure_boiler_internal: 2,
      high_pressure_boiler_external: 3,
      low_pressure_boiler: 4,
      cooling_tower: 5,
      elevator_periodic: 6,
      elevator_cat_1: 7,
      elevator_cat_3: 8,
      elevator_cat_5: 9,
      facade: 10,
      sprinkler_system: 11,
      standpipe_system: 12,
      window_guard: 13,
      energy_efficiency_ratings: 14,
      annual_property_registration: 15,
      parking_structure: 16,
      gas_piping: 17,
      energy_efficiency_ll_87: 18,
      energy_benchmarking: 19,
      energy_efficiency_ll_133: 20,
      drinking_water_storage_tank: 21,
      greenhouse_gas_emissions: 22,
      retaining_wall: 23
    }

    enum :department, {
      department_of_building: 0,
      new_york_city_fire_department: 1,
      department_of_health_and_mental_hygiene: 2,
      department_of_environmental_protection: 3,
      department_of_housing_preservation_and_development: 4
    }
  end
end
