# frozen_string_literal: true

class ViolationDecorator < Draper::Decorator
  delegate_all

  STATE_CLASSES = {
    'open' => 'badge-light-danger',
    'in_progress' => 'badge-light-primary',
    'closed' => 'badge-light-success'
  }.freeze

  SEVERITY_CLASSES = {
    'hazardous' => 'badge-light-warning',
    'immediately_hazardous' => 'badge-light-danger',
    'non_hazardous' => 'badge-light-primary'
  }.freeze

  def state
    clazz = STATE_CLASSES[object.state]
    h.content_tag(:span, class: "badge py-3 px-4 fs-7 #{clazz}") do
      I18n.t("violation_state.#{object.state}")
    end
  end

  def severity
    clazz = SEVERITY_CLASSES[object.severity]
    h.content_tag(:span, class: "badge py-3 px-4 fs-7 #{clazz}") do
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
