# frozen_string_literal: true

class ViolationsController < ApplicationController
  load_and_authorize_resource
  load_and_authorize_resource :building, only: :index

  def index
    @violations = @building.violations if @building
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
