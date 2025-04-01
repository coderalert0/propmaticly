# frozen_string_literal: true

module Abilities
  class UserAbility < ModelAbility
    def admin(user)
      can :manage, User, organization_id: user.organization_id
    end

    def root(_user)
      can :manage, User
    end
  end
end
