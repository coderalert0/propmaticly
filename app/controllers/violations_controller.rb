# frozen_string_literal: true

class ViolationsController < ApplicationController
  load_and_authorize_resource
  load_and_authorize_resource :building, only: :index

  def index
    @violations = @building.violations if @building
    @violations = @violations.order(:created_at, :desc).page(params[:page])
    @violations = PaginationDecorator.decorate(@violations)
  end

  def create
    violation = Violation.new(**create_update_hash)
    return unless violation.save!

    flash[:success] = t(:violation_create_success)
    redirect_to building_violations_path(violation.building)
  end

  def update
    return unless @violation.update(create_update_hash)

    flash[:success] = t(:violation_update_success)
    redirect_to building_violations_path(@violation.building)
  end

  def destroy
    return unless @violation.destroy

    flash[:success] = t(:violation_delete_success)
    redirect_to building_violations_path(@violation.building)
  end

  private

  def violation_params
    params.require(:violation).permit(:id, :violation_id, :violation_type, :description, :issue_date,
                                      :device_number, :device_type, :state, :severity, :building_id)
  end

  def create_update_hash
    {
      violation_id: violation_params[:violation_id],
      violation_type: violation_params[:violation_type],
      description: violation_params[:description],
      issue_date: violation_params[:issue_date],
      device_number: violation_params[:device_number],
      device_type: violation_params[:device_type],
      state: violation_params[:state],
      severity: violation_params[:severity],
      building_id: violation_params[:building_id]
    }
  end
end
