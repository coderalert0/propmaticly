# frozen_string_literal: true

class UserDecorator < Draper::Decorator
  delegate_all

  def confirmed?
    clazz = 'badge-light-danger' unless object.confirmed?
    h.content_tag(:span, class: "py-3 px-4 #{clazz}") do
      object.confirmed? ? I18n.t(:yes) : I18n.t(:no)
    end
  end

  def admin?
    object.admin? ? I18n.t(:yes) : I18n.t(:no)
  end
end
