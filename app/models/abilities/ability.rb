# frozen_string_literal: true

module Abilities
  class Ability
    include CanCan::Ability

    def initialize(user)
      nil unless user.present?
    end
  end
end
