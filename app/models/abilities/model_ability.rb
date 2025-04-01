# frozen_string_literal: true

module Abilities
  class ModelAbility
    include CanCan::Ability

    def initialize(user)
      can :read, InspectionRules::InspectionRule

      admin(user) if user.admin?
      root(user) if user.root?
      self.user(user) unless user.admin? || user.root?
    end

    def admin(user); end
    def root(user); end
    def user(user); end
  end
end
