# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    return unless user.present?

    can :manage, Building, id: user.buildings.pluck(:id)
    can :manage, Complaint, id: user.buildings.map(&:complaints).flatten.pluck(:id)
    can :manage, Violation, id: user.buildings.map(&:violations).flatten.pluck(:id)
    can :manage, Portfolio, id: user.buildings.map(&:portfolio).flatten.pluck(:id)
    can :manage, Inspection, id: user.buildings.map(&:inspections).flatten.pluck(:id)

    return unless user.admin?

    [Building, Complaint, Violation, Portfolio].each do |resource|
      can :manage, resource
    end

    can :manage, Building, id: user.organization.buildings.pluck(:id)
    can :manage, Complaint, id: user.organization.complaints.pluck(:id)
    can :manage, Violation, id: user.organization.violations.pluck(:id)
    can :manage, Portfolio, id: user.organization.portfolios.pluck(:id)
  end
end
