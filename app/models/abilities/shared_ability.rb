# frozen_string_literal: true

module Abilities
  module SharedAbility
    def complaint_attachments_can(user)
      user_building_ids = user.building_ids | user.portfolios&.flat_map(&:building_ids)
      complaint_ids = Complaints::Complaint.where(building_id: user_building_ids).pluck(:id)
      can :manage, ActiveStorage::Attachment, record_type: 'Complaints::Complaint', record_id: complaint_ids
    end

    def inspection_attachments_can(user)
      user_building_ids = user.building_ids | user.portfolios&.flat_map(&:building_ids)
      inspection_ids = Inspection.where(building_id: user_building_ids).pluck(:id)
      can :manage, ActiveStorage::Attachment, record_type: 'Inspection', record_id: inspection_ids
    end

    def violation_attachments_can(user)
      user_building_ids = user.building_ids | user.portfolios&.flat_map(&:building_ids)
      violation_ids = Violations::Violation.where(building_id: user_building_ids).pluck(:id)
      can :manage, ActiveStorage::Attachment, record_type: 'Violations::Violation', record_id: violation_ids
    end

    def complaint_attachments_admin_can(user)
      organization_complaint_ids = user.organization.complaint_ids
      can :manage, ActiveStorage::Attachment, record_type: 'Complaints::Complaint',
                                              record_id: organization_complaint_ids
    end

    def inspection_attachments_admin_can(user)
      organization_inspection_ids = user.organization.inspection_ids
      can :manage, ActiveStorage::Attachment, record_type: 'Inspection', record_id: organization_inspection_ids
    end

    def violation_attachments_admin_can(user)
      organization_violation_ids = user.organization.violation_ids
      can :manage, ActiveStorage::Attachment, record_type: 'Violations::Violation',
                                              record_id: organization_violation_ids
    end
  end
end
