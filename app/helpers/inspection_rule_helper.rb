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
      matches = entry.all? do |key, value|
        next true if ['end_date'].include?(key)

        key = rule.send(key) if rule.respond_to?(key)
        value == 'all' || Array(value).include?(building.instance_eval(key.to_s))
      end
      return Date.parse(entry['end_date']) if matches
    end
  end
end
