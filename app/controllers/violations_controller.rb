# frozen_string_literal: true

class ViolationsController < ApplicationController
  load_resource
  load_resource :building, only: :index

  def index
    @violations = if @building
                    @building.violations
                  else
                    current_user.organization.violations
                  end
    @violations = @violations.decorate.order(:created_at, :desc)
  end

  def update
    @violation.update(state: violation_params[:state].to_i)
    redirect_to violations_path, notice: t(:violation_update_success)
  end

  private

  def violation_params
    params.permit(:id, :state)
  end
end
