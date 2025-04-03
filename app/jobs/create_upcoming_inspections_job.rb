# frozen_string_literal: true

class CreateUpcomingInspectionsJob < ApplicationJob
  def perform(building_id: nil, end_date: 1.year.from_now, notify: false)
    @notify = notify

    building_ids = building_id ? [building_id] : Building.all.pluck(:id)
    buildings = Building.where(id: building_ids)

    buildings.each do |building|
      building.inspection_rules.each do |rule|
        next_inspection = rule.calculate_due_date(building)

        next_inspection.each do |device_id, next_inspection_date|
          next unless next_inspection_date && next_inspection_date <= end_date

          @inspection = building.inspections.find_or_create_by(device_id: device_id, inspection_rule: rule,
                                                               due_date: next_inspection_date)
          trigger_upcoming_inspection_notifier
        end
      rescue StandardError => e
        Rails.logger.error("Error creating upcoming inspection for inspection_rule #{rule} for building #{building.id}: #{e.message}")
      end
    end
  end

  private

  def trigger_upcoming_inspection_notifier
    return unless @notify && (@inspection.due_date <= Date.today >> 1)

    UpcomingInspectionNotifierJob.perform_later(@inspection.id)
  end
end
