# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    return unless user.present?

    can :read, InspectionRules::InspectionRule

    user_building_ids = user.building_ids | user.portfolios&.flat_map(&:building_ids)
    complaint_ids = Complaints::Complaint.where(building_id: user_building_ids).pluck(:id)
    violation_ids = Violations::Violation.where(building_id: user_building_ids).pluck(:id)
    inspection_ids = Inspection.where(building_id: user_building_ids).pluck(:id)

    can %i[read], Portfolio, buildings: { id: user_building_ids }
    can :create, Building, portfolio_id: user.portfolio_ids
    can %i[read update], Building, id: user_building_ids
    can %i[read update], Complaints::Complaint, building_id: user_building_ids
    can %i[read update], Violations::Violation, building_id: user_building_ids
    can :create, Inspection
    can %i[read update], Inspection, building_id: user_building_ids

    can :manage, ActiveStorage::Attachment, record_type: 'Complaints::Complaint', record_id: complaint_ids
    can :manage, ActiveStorage::Attachment, record_type: 'Violations::Violation', record_id: violation_ids
    can :manage, ActiveStorage::Attachment, record_type: 'Inspection', record_id: inspection_ids

    return unless user.admin?

    organization_complaint_ids = user.organization.complaint_ids
    organization_violation_ids = user.organization.violation_ids
    organization_inspection_ids = user.organization.inspection_ids

    [Portfolio, Building, Inspection].each do |model|
      can :create, model
    end

    can %i[read update destroy], Portfolio, id: user.organization.portfolio_ids
    can %i[read update destroy], Building, id: user.organization.building_ids
    can %i[read update], Complaints::Complaint, building_id: user.organization.building_ids
    can %i[read update], Violations::Violation, building_id: user.organization.building_ids
    can %i[read update], Inspection, building_id: user.organization.building_ids

    can :manage, ActiveStorage::Attachment, record_type: 'Complaints::Complaint', record_id: organization_complaint_ids
    can :manage, ActiveStorage::Attachment, record_type: 'Violations::Violation', record_id: organization_violation_ids
    can :manage, ActiveStorage::Attachment, record_type: 'Inspection', record_id: organization_inspection_ids
  end
end
