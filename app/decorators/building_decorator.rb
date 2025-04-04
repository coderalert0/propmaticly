# frozen_string_literal: true

class BuildingDecorator < Draper::Decorator
  delegate_all

  def address1
    "#{number} #{street}"
  end

  def open_complaints_link
    open_complaints = complaints.select { |c| c.state == 'open' }
    color_clazz = 'bg-danger text-white' if open_complaints.size.positive?
    h.link_to open_complaints.size, h.building_complaints_path(object, state: 'open'),
              class: "badge #{color_clazz} border rounded-0 bg-opacity-75"
  end

  def open_violations_link
    open_violations = violations.select { |c| c.state == 'open' }
    color_clazz = 'bg-danger text-white' if open_violations.size.positive?
    h.link_to open_violations.size, h.building_violations_path(object, state: 'open'),
              class: "badge #{color_clazz} border rounded-0 bg-opacity-75"
  end

  def upcoming_inspections_link
    upcoming_inspections = object.inspections.incomplete
    color_clazz = 'bg-warning text-white' if upcoming_inspections.size.positive?
    h.link_to upcoming_inspections.size, h.building_upcoming_inspections_path(object, state: 'open'),
              class: "badge #{color_clazz} border rounded-0 bg-opacity-75"
  end

  def past_inspections_link
    past_inspections = object.inspections.complete
    color_clazz = 'bg-primary text-white' if past_inspections.size.positive?
    h.link_to past_inspections.size, h.building_inspection_rules_path(object),
              class: "badge #{color_clazz} border rounded-0 bg-opacity-75"
  end
end
