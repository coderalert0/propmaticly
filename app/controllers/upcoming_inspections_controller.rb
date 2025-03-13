# frozen_string_literal: true

class UpcomingInspectionsController < ApplicationController
  load_and_authorize_resource :building
  load_and_authorize_resource class: 'Inspection', instance_name: :inspection

  def index
    @inspections = @building.inspections.upcoming
    @inspections = @inspections.send(params[:state]) if params[:state].present?

    if params[:search].present?
      search_term = "%#{params[:search].strip}%"

      @inspections = @inspections.joins(:inspection_rule)
                                 .where('inspection_rules.description::text ILIKE :search OR inspection_rules.compliance_item::text ILIKE :search', search: search_term)
    end

    @inspections = @inspections.order(:due_date).decorate
  end

  def update
    return unless @inspection.update(inspection_params)

    flash[:success] = t(:inspection_update_success)
    redirect_to building_upcoming_inspections_path(@building)
  end

  private

  def inspection_params
    params.require(:inspection).permit(:filing_date, :files, :state, :building_id, files: [])
  end
end
