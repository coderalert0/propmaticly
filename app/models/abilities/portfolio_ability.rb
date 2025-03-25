# frozen_string_literal: true

module Abilities
  class PortfolioAbility < ModelAbility
    def user(user)
      can %i[read], Portfolio, buildings: { id: user.building_ids }
      can %i[read], Portfolio, id: user.portfolio_ids
    end

    def admin(user)
      can :create, Portfolio
      can %i[read update destroy], Portfolio, id: user.organization.portfolio_ids
    end
  end
end
