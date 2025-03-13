# frozen_string_literal: true

class InspectionRuleDecorator < Draper::Decorator
  delegate_all

  def building_properties
    has_properties = object.has_properties.keys.map { |key| key.humanize.titleize }.join(', ')
    numerical_properties = object.numerical_properties.map do |key, value|
      "#{key.humanize.titleize}: #{value['value']}"
    end.join(', ')
    has_properties + numerical_properties
  end

  def compliance_item_inspections_link(building)
    h.link_to object.compliance_item.humanize.titleize,
              h.building_inspection_rule_inspections_path(building, object)
  end
end
