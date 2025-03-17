# frozen_string_literal: true

module InspectionRules
  class EnergyAuditsRetroCommissioning < InspectionRule
    def calculate_fixed_due_date
      day = fixed_day_month['day']
      month = fixed_day_month['month']

      tax_block_number_last_digit = @building.tax_block_number % 10
      base_year = (@current_date.year / 10) * 10 + tax_block_number_last_digit
      due_date = Date.new(base_year, month, day)

      due_date += frequency_in_months.months while due_date < @current_date
      { nil => due_date }
    end
  end
end
