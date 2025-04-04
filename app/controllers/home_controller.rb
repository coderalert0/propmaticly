# frozen_string_literal: true

class HomeController < ApplicationController
  def show
    @organization = current_organization
    @portfolios = current_organization.portfolios.accessible_by(current_ability).order(:name,
                                                                                       id: :asc).page(params[:page])
    @violations = current_organization.violations.accessible_by(current_ability)
    @complaints = current_organization.complaints.accessible_by(current_ability)
    @inspections = current_organization.inspections.accessible_by(current_ability)
  end
end
