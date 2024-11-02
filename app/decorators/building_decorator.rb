# frozen_string_literal: true

class BuildingDecorator < Draper::Decorator
  delegate_all

  def address1
    "#{number} #{street}"
  end
end
