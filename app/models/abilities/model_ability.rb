# frozen_string_literal: true

module Abilities
  class ModelAbility
    include CanCan::Ability

    def initialize(user)
      can :read, InspectionRules::InspectionRule

      if user.admin?
        admin(user)
      else
        self.user(user)
      end
    end

    def admin(user); end

    def user(user); end
  end
end
