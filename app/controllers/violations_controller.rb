# frozen_string_literal: true

class ViolationsController < ApplicationController
  load_and_authorize_resource
  load_and_authorize_resource :building, only: :index

  def index
    @violations = @building.violations if @building
    @violations = @violations.decorate.order(:created_at, :desc)
  end

  def create
    violation = Violation.new(number: violation_params[:number],
                              type_code: violation_params[:type_code],
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
    if @violation.update(number: violation_params[:number],
                         type_code: violation_params[:type_code],
                         category: violation_params[:category],
                         description: violation_params[:description],
                         comments: violation_params[:comments],
                         issue_date: violation_params[:issue_date],
                         disposition_date: violation_params[:disposition_date],
                         state: violation_params[:state],
                         building_id: violation_params[:building_id])

      flash[:success] = t(:violation_update_success)
      redirect_to building_violations_path(@violation.building)
    end
  end

  private

  def violation_params
    params.require(:violation).permit(:id, :number, :type_code, :category, :description, :comments,
                                      :issue_date, :disposition_date, :state, :building_id)
  end
end
