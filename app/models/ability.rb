# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    return unless user.present?

    can :manage, Portfolio, id: user.buildings.map(&:portfolio).flatten.pluck(:id)
    can :manage, Building, id: user.buildings.pluck(:id)
    can :manage, Complaints::Complaint, id: user.buildings.map(&:complaints).flatten.pluck(:id)
    can :manage, Violations::Violation, id: user.buildings.map(&:violations).flatten.pluck(:id)
    can :read, InspectionRules::InspectionRule

    restricted_rules = [
      InspectionRules::BedBugInspectionRule,
      InspectionRules::BoilerInspectionRule,
      InspectionRules::CoolingTowerInspectionRule,
      InspectionRules::ElevatorInspectionRule,
      InspectionRules::FacadeInspectionRule
    ]
    can :read, Inspection, inspection_rule: { type: restricted_rules.map(&:to_s) }

    return unless user.admin?

    [Building, Complaints::Complaint, Violations::Violation, Portfolio].each do |resource|
      can :manage, resource
    end

    can :manage, Portfolio, id: user.organization.portfolios.pluck(:id)
    can :manage, Building, id: user.organization.buildings.pluck(:id)
    can :manage, Complaints::Complaint, id: user.organization.complaints.pluck(:id)
    can :manage, Violations::Violation, id: user.organization.violations.pluck(:id)
  end
end
