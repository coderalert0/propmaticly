# frozen_string_literal: true

class InspectionsController < ApplicationController
  load_and_authorize_resource only: %i[update destroy]
  load_and_authorize_resource :building, only: :index
  load_and_authorize_resource :inspection_rule, only: :index

  def index
    @inspections = @building.inspections.filed.where(inspection_rule_id: @inspection_rule.id)

    if params[:search].present?
      search = "%#{params[:search].strip}%"
      @inspections = @inspections.where('data::text ILIKE ?', "%#{search}%")
    end

    @inspections = @inspections.order(filing_date: :desc).page(params[:page])
    @inspection_rule = @inspection_rule.decorate
  end
end
