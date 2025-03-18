# frozen_string_literal: true

module Abilities
  class ComplaintAbility < ModelAbility
    include Abilities::SharedAbility

    def user(user)
      user_building_ids = user.building_ids | user.portfolios&.flat_map(&:building_ids)
      can %i[read update], Complaints::Complaint, building_id: user_building_ids

      complaint_attachments_can(user)
    end

    def admin(user)
      organization_building_ids = user.organization.building_ids
      can %i[read update], Complaints::Complaint, building_id: organization_building_ids

      complaint_attachments_admin_can(user)
    end
  end
end
