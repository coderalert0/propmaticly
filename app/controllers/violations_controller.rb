# frozen_string_literal: true

class ViolationsController < ApplicationController
  load_and_authorize_resource
  load_and_authorize_resource :building, only: :index

  def index
    @violations = @building.violations if @building
    @violations = @violations.decorate.order(:created_at, :desc)
  end

  def update
    return unless @violation.update(state: violation_params[:state].to_i)

    flash[:success] = t(:violation_update_success)
    redirect_to violations_path
  end

  private

  def violation_params
    params.permit(:id, :state)
  end
end
