# frozen_string_literal: true

module Complaints
  class ComplaintDecorator < Draper::Decorator
    delegate_all

    STATE_CLASSES = {
      'open' => 'badge bg-warning',
      'closed' => 'badge bg-success',
      'in_progress' => 'badge bg-primary'
    }.freeze

    SEVERITY_CLASSES = {
      'emergency' => 'badge bg-warning',
      'immediate_emergency' => 'badge bg-danger',
      'non_emergency' => 'badge bg-primary'
    }.freeze

    def state
      state = object.resolved_date.present? ? 'closed' : object.state
      clazz = STATE_CLASSES[state]
      h.content_tag(:span, class: "badge text-white rounded-0 #{clazz}") do
        I18n.t("complaint_state.#{state}")
      end
    end

    def severity
      clazz = SEVERITY_CLASSES[object.severity]
      h.content_tag(:span, class: "badge text-white rounded-0 #{clazz}") do
        I18n.t("complaint_severity.#{object.severity}")
      end
    end

    def disposition_code
      I18n.t("disposition_code.#{object.disposition_code}") unless object.disposition_code.blank?
    end

    def self.categories_code_select
      [[]].concat(I18n.backend.send(:translations)[:en][:complaint_category].invert.to_a.sort_by do |key, _value|
        key
      end)
    end

    def self.disposition_codes_select
      [[]].concat(I18n.backend.send(:translations)[:en][:disposition_code].invert.to_a.sort_by do |key, _value|
        key
      end)
    end

    def self.states_select
      [[]].concat(I18n.backend.send(:translations)[:en][:complaint_state].invert.to_a)
    end

    def self.severities_select
      [[]].concat(I18n.backend.send(:translations)[:en][:complaint_severity].invert.to_a)
    end
  end
end
