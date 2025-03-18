# frozen_string_literal: true

module Violations
  class ViolationDecorator < Draper::Decorator
    delegate_all

    STATE_CLASSES = {
      'open' => 'badge bg-warning',
      'closed' => 'badge bg-success',
      'in_progress' => 'badge bg-primary'
    }.freeze

    SEVERITY_CLASSES = {
      'hazardous' => 'badge bg-warning',
      'immediately_hazardous' => 'badge bg-danger',
      'non_hazardous' => 'badge bg-primary'
    }.freeze

    def state
      state = object.resolved_date.present? ? 'closed' : object.state
      clazz = STATE_CLASSES[state]
      h.content_tag(:span, class: "badge text-white rounded-0 #{clazz}") do
        I18n.t("violation_state.#{state}")
      end
    end

    def severity
      clazz = SEVERITY_CLASSES[object.severity]
      h.content_tag(:span, class: "badge text-white rounded-0 #{clazz}") do
        I18n.t("violation_severity.#{object.severity}")
      end
    end

    def self.states_select
      [[]].concat(I18n.backend.send(:translations)[:en][:violation_state].invert.to_a)
    end

    def self.severity_select
      [[]].concat(I18n.backend.send(:translations)[:en][:violation_severity].invert.to_a)
    end
  end
end
