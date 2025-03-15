# frozen_string_literal: true

class BuildingDecorator < Draper::Decorator
  delegate_all

  def address1
    "#{number} #{street}"
  end

  def open_complaints_link
    color_clazz = 'bg-danger text-white' if complaints.open.size.positive?
    h.link_to complaints.open.size, h.building_complaints_path(object, state: 'open'),
              class: "badge #{color_clazz} border rounded-0 bg-opacity-75"
  end

  def open_violations_link
    color_clazz = 'bg-danger text-white' if violations.open.size.positive?
    h.link_to violations.open.size, h.building_violations_path(object, state: 'open'),
              class: "badge #{color_clazz} border rounded-0 bg-opacity-75"
  end

  def upcoming_inspections_link
    color_clazz = 'bg-warning text-white' if inspections.internal.pending.size.positive?
    h.link_to inspections.internal.pending.size, h.building_upcoming_inspections_path(object, state: 'pending'),
              class: "badge #{color_clazz} rounded-0 bg-opacity-75"
  end

  def past_inspections_link
    color_clazz = 'bg-primary text-white' if inspections.external.size.positive?
    h.link_to inspections.external.size, h.building_inspection_rules_path(object),
              class: "badge #{color_clazz} rounded-0 bg-opacity-75"
  end
end
