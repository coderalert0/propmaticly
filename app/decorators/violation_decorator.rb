# frozen_string_literal: true

class ViolationDecorator < Draper::Decorator
  delegate_all

  def state
    clazz = case object.state
            when 'open', 'Open', 'Active', 'ACTIVE'
              'badge-light-danger'
            when 'in_progress'
              'badge-light-primary'
            when 'closed', 'Close', 'Dismissed', 'RESOLVE'
              'badge-light-success'
            end
    h.content_tag(:span, class: "badge py-3 px-4 fs-7 #{clazz}") do
      I18n.t("violation_state.#{object.state}")
    end
  end

  def severity
    clazz = case object.severity
            when 'Emergency', 'Hazardous'
              'badge-light-danger'
            when 'Non-Emergency', 'Non-Hazardous'
              'badge-light-success'
            end
    h.content_tag(:span, class: "badge py-3 px-4 fs-7 #{clazz}") do
      object.severity
    end
  end

  def self.states_select
    [['Open', 'open'], ['In Progress', 'in_progress'], ['Closed', 'closed']]
  end
end
