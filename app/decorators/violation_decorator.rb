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
end
