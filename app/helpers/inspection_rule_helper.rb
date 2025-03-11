# frozen_string_literal: true

module InspectionRuleHelper
  def self.calculate_fixed_deadline_date(rule, start_date)
    day = rule.fixed_day # check if a dedicated column or jsonb is better
    month = rule.fixed_month

    # need to make this more dynamic based on frequency_in_months, cant assume 1 year
    deadline = Date.new(start_date.year, month, day)
    return deadline if deadline >= start_date

    Date.new(start_date.year + 1, month, day)
  end

  def self.calculate_cycle_inspection_deadline_date(rule, borough, district)
    rule.cycle_schedule.each do |entry|
      boroughs = entry['boroughs']
      districts = entry['districts']
      borough_match = boroughs == 'all' || boroughs.include?(borough)
      district_match = districts == 'all' || districts.include?(district)
      return Date.parse(entry['end_date']) if borough_match && district_match
    end
  end
end
