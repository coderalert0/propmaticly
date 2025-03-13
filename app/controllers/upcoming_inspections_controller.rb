# frozen_string_literal: true

class UpcomingInspectionsController < ApplicationController
  load_and_authorize_resource :building

  def index
    @inspections = @building.inspections.pending

    if params[:search].present?
      search_term = "%#{params[:search].strip}%"

      @inspections = @inspections.joins(:inspection_rule)
                                 .where('inspection_rules.description::text ILIKE :search OR inspection_rules.compliance_item::text ILIKE :search', search: search_term)
    end

    @inspections = @inspections.order(:due_date).decorate
  end
end
