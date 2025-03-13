# frozen_string_literal: true

class InspectionRule < ApplicationRecord
  has_many :inspections, dependent: :destroy

  validates :compliance_item, :frequency_in_months, presence: true

  enum compliance_item: {
    backflow_prevention: 0,
    bed_bug: 1,
    high_pressure_boiler_internal: 2,
    high_pressure_boiler_external: 3,
    low_pressure_boiler: 4,
    cooling_tower: 5,
    elevator_periodic: 6,
    elevator_cat_1: 6,
    elevator_cat_3: 6,
    elevator_cat_5: 6,
    facade: 7,
    sprinkler_system: 8,
    standpipe_system: 9,
    window_guard: 10,
    energy_efficiency_ratings: 11,
    annual_property_registration: 12,
    parking_structure: 13,
    gas_piping: 14,
    energy_efficiency_ll_87: 15,
    energy_benchmarking: 16,
    energy_efficiency_ll_133: 17,
    drinking_water_storage_tank: 18,
    greenhouse_gas_emissions: 19,
    retaining_wall: 20
  }

  enum department: {
    department_of_building: 0,
    new_york_city_fire_department: 1,
    department_of_health_and_mental_hygiene: 2,
    department_of_environmental_protection: 3,
    department_of_housing_preservation_and_development: 4
  }
end
