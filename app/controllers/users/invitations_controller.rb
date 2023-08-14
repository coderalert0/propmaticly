# frozen_string_literal: true

module Users
  class InvitationsController < Devise::InvitationsController
    def new
      @portfolios = Portfolio.all
      @buildings = Building.all
      super
    end

    def create
      self.resource = invite_resource
      resource_invited = resource.errors.empty?

      yield resource if block_given?

      if resource_invited
        invite_params[:building_ids].map { |building_id| BuildingUser.create(user: resource, building_id: building_id) }

        if is_flashing_format? && self.resource.invitation_sent_at
          set_flash_message :notice, :send_instructions, email: self.resource.email
        end
        if self.method(:after_invite_path_for).arity == 1
          respond_with resource, location: after_invite_path_for(current_inviter)
        else
          respond_with resource, location: after_invite_path_for(current_inviter, resource)
        end
      else
        respond_with(resource)
      end
    end

    def invite_params
      params.require(:user).permit(:first_name, :last_name, :email, :sms, building_ids: []).merge(organization: organization)
    end

    def organization
      current_user.organization
    end
  end
end
