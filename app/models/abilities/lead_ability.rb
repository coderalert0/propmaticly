# frozen_string_literal: true

module Abilities
  class LeadAbility < ModelAbility
    def admin(_user)
      can :read, Lead
    end
  end
end
