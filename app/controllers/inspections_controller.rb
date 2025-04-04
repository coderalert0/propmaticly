# frozen_string_literal: true

class InspectionsController < ApplicationController
  load_and_authorize_resource only: %i[update destroy]
  load_and_authorize_resource :building, only: :index
  load_and_authorize_resource :inspection_rule, class: 'InspectionRules::InspectionRule', only: :index

  after_action :trigger_create_upcoming_inspections_job, only: :create

  def index
    @inspections = @building.inspections.includes(:attachments_attachments,
                                                  :audits).complete.where(inspection_rule_id: @inspection_rule.id)

    if params[:search].present?
      search = "%#{params[:search].strip}%"
      @inspections = @inspections.where('data::text ILIKE ?', "%#{search}%")
    end

    @inspections = @inspections.order(filing_date: :desc, id: :asc).page(params[:page])
    @inspections = PaginationDecorator.decorate(@inspections)
    @inspection_rule = @inspection_rule.decorate
  end

  def create
    inspection_rule = InspectionRules::InspectionRule.find(inspection_params[:inspection_rule_id])
    @inspection = Inspection.new(inspection_params)

    device_key = InspectionRules::InspectionRule::DEVICE_IDENTIFIER[inspection_rule.compliance_item.to_sym]

    if device_key && device_key != 'device_id'
      device_key = device_key&.split("->>'")&.last&.delete_suffix("'")
      @inspection['data'][device_key] = inspection_params[:device_id]
      @inspection['data']['filing_date'] = inspection_params[:filing_date]
      @inspection['data']['inspection_date'] = inspection_params[:filing_date]
    end

    return unless @inspection.save

    flash[:success] = t(:inspection_create_success)
  end

  private

  def inspection_params
    params.require(:inspection).permit(:device_id, :filing_date, :inspection_rule_id,
                                       :building_id).merge({ state: :closed })
  end

  def trigger_create_upcoming_inspections_job
    CreateUpcomingInspectionsJob.perform_later(building_id: @building)
  end
end
