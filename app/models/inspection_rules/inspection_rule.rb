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
      retaining_wall: 23,
      energy_audits_retro_commissioning: 24
    }

    enum :department, {
      department_of_building: 0,
      new_york_city_fire_department: 1,
      department_of_health_and_mental_hygiene: 2,
      department_of_environmental_protection: 3,
      department_of_housing_preservation_and_development: 4
    }

    def calculate_due_date(building)
      @building = building
      @current_date = Date.today

      if fixed_day_month.present?
        calculate_fixed_due_date
      elsif based_on_last_inspection == true
        calculate_due_date_based_on_last_inspection
      elsif cycle_schedule.present?
        calculate_cycle_due_date
      end
    end

    def calculate_fixed_due_date
      day = fixed_day_month['day']
      month = fixed_day_month['month']

      due_date = Date.new(@current_date.year, month, day)

      due_date += frequency_in_months.months while due_date < @current_date
      due_date
    end

    def calculate_due_date_based_on_last_inspection
      latest_filing_dates = Inspection.completed.where(inspection_rule_id: id,
                                                       building: @building).group(:device_id).maximum(:filing_date)
      latest_filing_dates.transform_values do |filing_date|
        filing_date + frequency_in_months.months
      end
    end

    def calculate_cycle_due_date
      cycle_schedule.each do |entry|
        matches = entry.all? do |key, value|
          next true if ['end_date'].include?(key)

          key = send(key) if respond_to?(key)
          value == 'all' || Array(value).include?(@building.instance_eval(key.to_s))
        end
        return Date.parse(entry['end_date']) if matches
      end
    end
  end
end
