# frozen_string_literal: true

class UpcomingInspectionsController < ApplicationController
  load_and_authorize_resource :building
  load_and_authorize_resource class: 'Inspection', instance_name: :inspection

  def index
    @inspections = @building.inspections.internal
    @inspections = @inspections.internal.send(params[:state]) if params[:state].present?

    if params[:search].present?
      search_term = "%#{params[:search].strip}%"

      @inspections = @inspections.joins(:inspection_rule)
                                 .where('inspection_rules.description::text ILIKE :search OR inspection_rules.compliance_item::text ILIKE :search', search: search_term)
    end

    @inspections = @inspections.order(:due_date).page(params[:page])
    @inspections = PaginationDecorator.decorate(@inspections)
  end

  def update
    modifiable_params = inspection_params.dup

    modifiable_params[:filing_date] = nil unless modifiable_params[:state] == 'closed'

    if @inspection.update(modifiable_params)
      flash[:success] = t(:inspection_update_success)
    else
      flash[:danger] = @inspection.errors.full_messages
    end
  end

  private

  def inspection_params
    params.require(:inspection).permit(:state, :audit_comment, :building_id, :filing_date, attachments: [])
  end
end
