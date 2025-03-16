# frozen_string_literal: true

class InspectionDecorator < Draper::Decorator
  delegate_all

  STATUS_CLASSES = {
    'open' => 'badge-light-warning',
    'closed' => 'badge-light-success',
    'in_progress' => 'badge-light-primary'
  }.freeze

  def state
    clazz = STATUS_CLASSES[object.state]
    h.content_tag(:span, class: "badge py-3 px-4 fs-7 #{clazz}") do
      I18n.t("inspection_state.#{object.state}")
    end
  end

  def self.states_select
    [[]].concat(I18n.backend.send(:translations)[:en][:inspection_state].invert.to_a)
  end
end
