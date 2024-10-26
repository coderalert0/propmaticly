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
        binding.break
        AssetContact.assign_assets_to_user('Portfolio', invite_params[:portfolio_ids], resource)
        AssetContact.assign_assets_to_user('Building', invite_params[:building_ids], resource)

        if is_flashing_format? && resource.invitation_sent_at
          set_flash_message :notice, :send_instructions, email: resource.email
        end
        respond_with resource, location: users_path
      else
        respond_with(resource)
      end
    end

    def invite_params
      params.require(:user).permit(:first_name, :last_name, :email, :sms, :admin, building_ids: [],
                                                                                  portfolio_ids: []).merge(organization: current_organization)
    end
  end
end
