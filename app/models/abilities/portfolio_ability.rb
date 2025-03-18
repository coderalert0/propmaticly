# frozen_string_literal: true

module Abilities
  class PortfolioAbility < ModelAbility
    def user(user)
      user_building_ids = user.building_ids | user.portfolios&.flat_map(&:building_ids)
      can %i[read], Portfolio, buildings: { id: user_building_ids }
    end

    def admin(user)
      can :create, Portfolio
      can %i[read update destroy], Portfolio, id: user.organization.portfolio_ids
    end
  end
end
