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

  def header
    headers = object.class.highlighted_attributes.map do |attribute|
      "<th>#{attribute}</th>"
    end

    <<~HTML
      <thead>
        <tr class="text-start text-gray-400 fw-bold fs-7 text-uppercase gs-0">
          #{headers.join("\n")}
          <th class="text-end min-w-100px">Actions</th>
        </tr>
      </thead>
    HTML
  end
end
