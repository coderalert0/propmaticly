# frozen_string_literal: true

class CreateUpcomingInspectionsJob < ApplicationJob
  def perform(building: nil, end_date: 1.year.from_now)
    buildings = building ? [building] : Building.all

    buildings.each do |building|
      building.inspection_rules.each do |rule|
        next_inspection = rule.calculate_due_date(building)

        if next_inspection.is_a? Hash
          next_inspection.each do |device_id, next_inspection_date|
            next unless next_inspection_date && next_inspection_date <= end_date

            building.inspections.find_or_create_by(device_id: device_id, inspection_rule: rule,
                                                   due_date: next_inspection_date)
          end
        else
          next unless next_inspection && next_inspection <= end_date

          building.inspections.find_or_create_by(inspection_rule: rule, due_date: next_inspection)
        end
      end
    end
  end
end
