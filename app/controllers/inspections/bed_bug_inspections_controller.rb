# frozen_string_literal: true

module Inspections
  class BedBugInspectionsController < ApplicationController
    load_and_authorize_resource only: %i[update destroy]
    load_and_authorize_resource :building, only: :index

    def index
      @bed_bug_inspections = @building.bed_bug_inspections

      if params[:search].present?
        search = "%#{params[:search].strip}%"
        @bed_bug_inspections = @bed_bug_inspections.where('registration_id LIKE ?', search)
      end

      @bed_bug_inspections = @bed_bug_inspections.order(filing_date: :desc).page(params[:page])
    end

    def create
      inspection = BedBugInspection.new(**create_update_hash)
      return unless inspection.save!

      flash[:success] = t(:violation_create_success)
      redirect_to building_inspections_bed_bug_inspections_path(inspection.building)
    end

    def update
      return unless @bed_bug_inspection.update(create_update_hash)

      flash[:success] = t(:inspection_update_success)
      redirect_to building_inspections_bed_bug_inspections_path(@bed_bug_inspection.building)
    end

    def destroy
      return unless @bed_bug_inspection.destroy

      flash[:success] = t(:inspection_delete_success)
      redirect_to building_inspections_bed_bug_inspections_path(@bed_bug_inspection.building)
    end

    private

    def inspection_params
      params.require(:inspections_bed_bug_inspection).permit(:registration_id, :of_dwelling_units, :infested_dwelling_unit_count,
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
      InspectionRule.find_by(compliance_item: :bed_bug).id
    end
  end
end
