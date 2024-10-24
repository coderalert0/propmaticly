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
        invite_params[:building_ids].each do |building_id|
          AssetContact.create(user: resource, assignable: Building.find(building_id))
        end

        if is_flashing_format? && resource.invitation_sent_at
          set_flash_message :notice, :send_instructions, email: resource.email
        end
        respond_with resource, location: users_path
      else
        respond_with(resource)
      end
    end

    def invite_params
      params.require(:user).permit(:first_name, :last_name, :email, :sms, :admin,
                                   building_ids: []).merge(organization: organization)
    end

    def organization
      current_user.organization
    end
  end
end
