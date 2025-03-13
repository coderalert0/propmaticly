# frozen_string_literal: true

module InspectionRuleHelper
  def self.calculate_due_date(rule, building)
    if rule.fixed_day_month
      calculate_fixed_due_date(rule)
    elsif rule.cycle_schedule
      calculate_cycle_inspection_due_date(rule, building)
    end
  end

  def self.calculate_fixed_due_date(rule)
    current_date = Date.today

    day = rule.fixed_day_month['day']
    month = rule.fixed_day_month['month']

    # need to make this more dynamic based on frequency_in_months, cant assume 1 year
    due_date = Date.new(current_date.year, month, day)
    return due_date if due_date >= current_date

    Date.new(current_date.year + 1, month, day)
  end

  def self.calculate_cycle_inspection_due_date(rule, building)
    rule.cycle_schedule.each do |entry|
      boroughs = entry['boroughs']
      districts = entry['districts']
      borough_match = boroughs == 'all' || boroughs.include?(building.borough_code)
      district_match = districts == 'all' || districts.include?(building.community_district_number)
      return Date.parse(entry['end_date']) if borough_match && district_match
    end
  end
end
