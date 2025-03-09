# frozen_string_literal: true

class InspectionRulesController < ApplicationController
  load_and_authorize_resource :building

  def index
    @inspection_rules = @building.inspection_rules.sort_by(&:compliance_item)
    @inspection_rules = Kaminari.paginate_array(@inspection_rules).page(params[:page]).per(15)
    @inspection_rules = PaginationDecorator.decorate(@inspection_rules)
  end
end
