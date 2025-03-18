# frozen_string_literal: true

class UserDecorator < Draper::Decorator
  delegate_all

  def confirmed?
    clazz = 'badge bg-danger text-white rounded-0' unless object.confirmed?
    h.content_tag(:span, class: clazz.to_s) do
      object.confirmed? ? I18n.t(:yes) : I18n.t(:no)
    end
  end

  def admin?
    object.admin? ? I18n.t(:yes) : I18n.t(:no)
  end

  def first_last_name
    "#{object.first_name} #{object.last_name}"
  end
end
