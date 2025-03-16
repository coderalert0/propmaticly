# frozen_string_literal: true

class InspectionRulesController < ApplicationController
  load_and_authorize_resource :building

  def index
    compliance_items = %w[standpipe_system sprinkler_system backflow_prevention]
    @missing_inspections = InspectionRules::InspectionRule.where(compliance_item: compliance_items).where.missing(:inspections).pluck(:compliance_item)
    @missing_inspections = @missing_inspections.map(&:titleize).to_sentence

    @inspection_rules = @building.inspection_rules.sort_by(&:compliance_item)
    @inspection_rules = Kaminari.paginate_array(@inspection_rules).page(params[:page]).per(20)
    @inspection_rules = PaginationDecorator.decorate(@inspection_rules)
  end
end
