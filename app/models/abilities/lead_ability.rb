# frozen_string_literal: true

module Abilities
  class LeadAbility < ModelAbility
    def root(_user)
      can :manage, Lead
    end
  end
end
