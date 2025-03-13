# frozen_string_literal: true

class CreateUpcomingInspectionsJob < ApplicationJob
  def perform(building: nil, end_date: 1.year.from_now)
    buildings = building ? [building] : Building.all

    buildings.each do |building|
      building.inspection_rules.each do |rule|
        next_inspection_date = InspectionRuleHelper.calculate_due_date(rule, building)
        next unless next_inspection_date && next_inspection_date <= end_date

        building.inspections.find_or_create_by(
          inspection_rule: rule,
          due_date: next_inspection_date
        ) do |inspection|
          inspection.status = :pending
        end
      end
    end
  end
end
