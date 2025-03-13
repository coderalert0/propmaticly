# frozen_string_literal: true

class InspectionDecorator < Draper::Decorator
  delegate_all

  STATUS_CLASSES = {
    'pending' => 'badge-light-warning',
    'completed' => 'badge-light-success',
    'overdue' => 'badge-light-danger'
  }.freeze

  def state
    state = if object.filing_date.present?
              'completed'
            elsif object.due_date.present? && object.due_date < Date.today
              'overdue'
            else
              'pending'
            end
    clazz = STATUS_CLASSES[state]
    h.content_tag(:span, class: "badge py-3 px-4 fs-7 #{clazz}") do
      I18n.t("inspection_state.#{state}")
    end
  end

  def self.states_select
    [[]].concat(I18n.backend.send(:translations)[:en][:inspection_state].invert.to_a)
  end
end
