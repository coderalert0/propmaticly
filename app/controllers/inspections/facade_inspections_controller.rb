# frozen_string_literal: true

module Inspections
  class FacadeController < ApplicationController
    load_and_authorize_resource :building

    def index
      @inspections = @building.facade_inspections.order(filing_date: :desc).page(params[:page])
    end
  end
end
