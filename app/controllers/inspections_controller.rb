# frozen_string_literal: true

class InspectionsController < ApplicationController
  load_and_authorize_resource only: %i[update destroy]
  load_and_authorize_resource :building, only: :index
  load_and_authorize_resource :inspection_rule, only: :index

  def index
    @inspections = @building.inspections.where(inspection_rule_id: @inspection_rule.id)

    if params[:search].present?
      search = "%#{params[:search].strip}%"
      # update boiler_id to dynamic attribute search
      @inspections = @inspections.where('data::text ILIKE ?', "%#{search}%")
    end

    @inspections = @inspections.order(filing_date: :desc).page(params[:page])
  end

  def create
    inspection = BedBugInspection.new(**create_update_hash)
    return unless inspection.save!

    flash[:success] = t(:violation_create_success)
    redirect_to building_inspections_inspections_path(inspection.building)
  end

  def update
    return unless @inspection.update(create_update_hash)

    flash[:success] = t(:inspection_update_success)
    redirect_to building_inspections_inspections_path(@inspection.building)
  end

  def destroy
    return unless @inspection.destroy

    flash[:success] = t(:inspection_delete_success)
    redirect_to building_inspections_path(@inspection.building)
  end

  private

  def inspection_params
    params.require(:inspection).permit(:registration_id, :of_dwelling_units, :infested_dwelling_unit_count,
                                       :eradicated_unit_count, :re_infested_dwelling_unit, :filing_date,
                                       :filing_period_start_date, :filling_period_end_date, :building_id)
  end

  def create_update_hash
    {
      registration_id: inspection_params[:registration_id],
      of_dwelling_units: inspection_params[:of_dwelling_units],
      infested_dwelling_unit_count: inspection_params[:infested_dwelling_unit_count],
      eradicated_unit_count: inspection_params[:eradicated_unit_count],
      re_infested_dwelling_unit: inspection_params[:re_infested_dwelling_unit],
      filing_date: inspection_params[:filing_date],
      filing_period_start_date: inspection_params[:filing_period_start_date],
      filling_period_end_date: inspection_params[:filling_period_end_date],
      building_id: inspection_params[:building_id]
    }.merge!(inspection_rule_id: inspection_rule)
  end

  def inspection_rule
    # probably will be input from a form dropdown for creating only
    InspectionRule.find_by(compliance_item: :bed_bug).id
  end
end
