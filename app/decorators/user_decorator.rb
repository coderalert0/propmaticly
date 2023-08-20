# frozen_string_literal: true

class UserDecorator < Draper::Decorator
  delegate_all

  def confirmed?
    clazz = object.confirmed? ? 'badge-light-success' : 'badge-light-danger'
    h.content_tag(:span, class: "badge py-3 px-4 fs-7 #{clazz}") do
      object.confirmed? ? 'Yes' : 'No'
    end
  end

  def admin?
    object.admin? ? 'Yes' : 'No'
  end
end
