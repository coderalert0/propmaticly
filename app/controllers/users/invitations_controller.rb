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

      return unless resource.invitation_sent_at

      set_flash_message :success, :send_instructions, email: resource.email
    end

    private

    def invite_params
      params.require(:user).permit(:first_name, :last_name, :email, :title, :sms, :admin, building_ids: [],
                                                                                          portfolio_ids: []).merge(organization: current_organization)
    end

    def invite_resource
      user = nil
      ActiveRecord::Base.transaction do
        user_attributes = invite_params.except(:building_ids, :portfolio_ids)
        user = User.invite!(user_attributes, current_user)

        if user.errors.present?
          message = "Failed to send invitation for #{invite_params}: #{user.errors.full_messages.join(', ')}"
          Rails.logger.error message
          raise StandardError, message
        end

        user.update(portfolio_ids: invite_params[:portfolio_ids], building_ids: invite_params[:building_ids])
      end
      user
    rescue StandardError => e
      Rails.logger.error "Failed to send invitation: #{e.message}"
      user
    end
  end
end
