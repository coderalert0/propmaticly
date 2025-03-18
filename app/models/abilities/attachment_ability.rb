# frozen_string_literal: true

module Abilities
  class AttachmentAbility < ModelAbility
    include Abilities::SharedAbility

    def user(user)
      complaint_attachments_can(user)
      inspection_attachments_can(user)
      violation_attachments_can(user)
    end

    def admin(user)
      complaint_attachments_admin_can(user)
      inspection_attachments_admin_can(user)
      violation_attachments_admin_can(user)
    end
  end
end
