# frozen_string_literal: true

class ViolationsController < ApplicationController
  load_and_authorize_resource
  load_and_authorize_resource :building, only: :index

  def index
    @violations = @building.violations if @building
    @violations = @violations.order(:created_at, :desc).page(params[:page]).per(10)
    @violations = PaginationDecorator.decorate(@violations)
  end

  def create
    violation = Violation.new(number: violation_params[:violation_id],
                              type: violation_params[:type_code],
                              category: violation_params[:category],
                              description: violation_params[:description],
                              comments: violation_params[:comments],
                              issue_date: violation_params[:issue_date],
                              disposition_date: violation_params[:disposition_date],
                              state: violation_params[:state],
                              building_id: violation_params[:building_id])

    return unless violation.save!

    flash[:success] = t(:violation_create_success)
    redirect_to building_violations_path(violation.building)
  end

  def update
    if @violation.update(violation_id: violation_params[:violation_id],
                         violation_type: violation_params[:violation_type],
                         description: violation_params[:description],
                         issue_date: violation_params[:issue_date],
                         device_number: violation_params[:device_number],
                         device_type: violation_params[:device_type],
                         building_id: violation_params[:building_id])

      flash[:success] = t(:violation_update_success)
      redirect_to building_violations_path(@violation.building)
    end
  end

  private

  def violation_params
    params.require(:violation).permit(:id, :violation_id, :violation_type, :description,
                                      :issue_date, :device_number, :device_type, :state, :building_id)
  end
end
