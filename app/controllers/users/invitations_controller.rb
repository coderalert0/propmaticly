# frozen_string_literal: true

module Users
  class InvitationsController < Devise::InvitationsController
    def new
      @portfolios = current_organization.portfolios
      @buildings = current_organization.buildings
      super
    end

    def create
      self.resource = invite_resource
      resource_invited = resource.errors.empty?

      yield resource if block_given?

      return unless resource_invited

      AssetContact.assign_assets_to_user('Portfolio', invite_params[:portfolio_ids], resource)
      AssetContact.assign_assets_to_user('Building', invite_params[:building_ids], resource)

      return unless resource.invitation_sent_at

      set_flash_message :success, :send_instructions, email: resource.email
    end

    def invite_params
      params.require(:user).permit(:first_name, :last_name, :email, :sms, :admin, building_ids: [],
                                                                                  portfolio_ids: []).merge(organization: current_organization)
    end
  end
end
