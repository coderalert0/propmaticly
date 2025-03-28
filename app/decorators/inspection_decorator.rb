# frozen_string_literal: true

class InspectionDecorator < Draper::Decorator
  delegate_all

  STATUS_CLASSES = {
    'open' => 'badge bg-warning',
    'closed' => 'badge bg-success',
    'in_progress' => 'badge bg-primary'
  }.freeze

  def state
    clazz = STATUS_CLASSES[object.state]
    h.content_tag(:span, class: "badge text-white rounded-0 #{clazz}") do
      I18n.t("inspection_state.#{object.state}")
    end
  end

  def self.states_select
    [[]].concat(I18n.backend.send(:translations)[:en][:inspection_state].invert.to_a)
  end

  def data_value(attribute)
    value = data[attribute.to_s]
    if value && %w[date submitted_on].any? { attribute.to_s.include?(_1) }
      Date.parse(value)&.strftime('%D')
    else
      value
    end
  end
end
