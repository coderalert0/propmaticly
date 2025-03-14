# frozen_string_literal: true

module InspectionRules
  class InspectionRuleDecorator < Draper::Decorator
    delegate_all

    COMPLIANCE_HEADERS = {
      'bed_bug' => %i[registration_id of_dwelling_units infested_dwelling_unit_count eradicated_unit_count
                      re_infested_dwelling_unit filing_date],
      'low_pressure_boiler' => %i[boiler_id report_type boiler_make boiler_model pressure_type inspection_type
                                  inspection_date defects_exist report_status],
      'high_pressure_boiler' => %i[boiler_id report_type boiler_make boiler_model pressure_type inspection_type
                                   inspection_date defects_exist report_status],
      'cooling_tower' => %i[system_id status active_equip inspection_type inspection_date violation_code violation_type
                            law_section],
      'elevator' => %i[device_number device_type device_status status_date equipment_type periodic_report_year
                       cat1_report_year cat1_latest_report_filed cat5_latest_report_filed periodic_latest_inspection],
      'facade' => %i[tr6_no control_no filing_type cycle sequence_no submitted_on filing_date current_status
                     filing_status],
      'drinking_water_storage_tank' => %i[confirmation_num reporting_year tank_num inspection_date sample_collected
                                          inspection_by_firm]
    }.freeze

    def building_properties
      has_properties = object.has_properties.keys.map { |key| key.humanize.titleize }.join(', ')
      numerical_properties = object.numerical_properties.map do |key, value|
        "#{key.humanize.titleize}: #{value['value']}"
      end.join(', ')
      has_properties + numerical_properties
    end

    def compliance_item_inspections_link(building)
      h.link_to compliance_item_humanize,
                h.building_inspection_rule_inspections_path(building, object)
    end

    def headers
      COMPLIANCE_HEADERS[object.compliance_item] || []
    end

    def header_html
      header_cells = headers.map do |attribute|
        "<th>#{attribute.to_s.humanize}</th>"
      end.join.html_safe

      <<~HTML.html_safe
        <thead>
          <tr class="text-start text-gray-400 fw-bold fs-7 text-uppercase gs-0">
            #{header_cells}
            <th class="text-end min-w-100px">Actions</th>
          </tr>
        </thead>
      HTML
    end

    def compliance_item_humanize
      object.compliance_item.humanize.titleize
    end
  end
end
