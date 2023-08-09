# frozen_string_literal: true

module Users
  class InvitationsController < Devise::InvitationsController
    def new
      @portfolios = Portfolio.all
      @buildings = Building.all
      super
    end

    def invite_params
      devise_parameter_sanitizer.sanitize(:invite).merge(organization: organization)
    end

    def organization
      current_user.organization
    end
  end
end
