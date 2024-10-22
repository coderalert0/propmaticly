# frozen_string_literal: true

class ViolationDecorator < Draper::Decorator
  delegate_all

  def state
    clazz = case object.state
            when 'open'
              'badge-light-danger'
            when 'in_progress'
              'badge-light-primary'
            when 'closed'
              'badge-light-success'
            end
    h.content_tag(:span, class: "badge py-3 px-4 fs-7 #{clazz}") do
      I18n.t("violation_state.#{object.state}")
    end
  end

  def severity
    clazz = case object.severity
            when 'hazardous'
              'badge-light-warning'
            when 'immediately_hazardous'
              'badge-light-danger'
            when 'non_hazardous'
              'badge-light-primary'
            end
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
