# frozen_string_literal: true

module Abilities
  class BuildingAbility < ModelAbility
    def user(user)
      user_building_ids = user.building_ids | user.portfolios&.flat_map(&:building_ids)

      can :create, Building do |building|
        user.portfolio_ids.include?(building.portfolio_id)
      end

      can %i[read update], Building, id: user_building_ids
    end

    def admin(user)
      organization_building_ids = user.organization.building_ids

      can :create, Building
      can %i[read update destroy], Building, id: organization_building_ids
    end
  end
end
