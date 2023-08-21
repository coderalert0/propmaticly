# frozen_string_literal: true

class UserDecorator < Draper::Decorator
  delegate_all

  def confirmed?
    clazz = 'badge-light-danger' unless object.confirmed?
    h.content_tag(:span, class: "py-3 px-4 #{clazz}") do
      object.confirmed? ? 'Yes' : 'No'
    end
  end

  def admin?
    object.admin? ? 'Yes' : 'No'
  end
end
