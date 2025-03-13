# frozen_string_literal: true

class InspectionDecorator < Draper::Decorator
  delegate_all

  STATUS_CLASSES = {
    'pending' => 'badge-light-danger',
    'completed' => 'badge-light-success'
  }.freeze

  def status
    clazz = STATUS_CLASSES[object.status]
    h.content_tag(:span, class: "badge py-3 px-4 fs-7 #{clazz}") do
      I18n.t("inspection_status.#{object.status}")
    end
  end
end
