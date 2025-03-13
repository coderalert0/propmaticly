# frozen_string_literal: true

class InspectionDecorator < Draper::Decorator
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
                   filing_status]
  }.freeze

  def headers
    COMPLIANCE_HEADERS[inspection_rule.compliance_item] || []
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
end
