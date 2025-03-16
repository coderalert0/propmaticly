# frozen_string_literal: true

class InspectionRulesController < ApplicationController
  load_and_authorize_resource :building

  def index
    @compliance_items_missing_last_inspection_dates = @building&.inspection_rules&.select(&:based_on_last_inspection)&.map(&:decorate)&.map(&:compliance_item_humanize)&.join(', ')
    @inspection_rules = @building.inspection_rules.sort_by(&:compliance_item)
    @inspection_rules = Kaminari.paginate_array(@inspection_rules).page(params[:page]).per(20)
    @inspection_rules = PaginationDecorator.decorate(@inspection_rules)
  end
end
