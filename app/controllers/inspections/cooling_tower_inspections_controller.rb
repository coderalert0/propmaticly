# frozen_string_literal: true

module Inspections
  class CoolingTowersController < ApplicationController
    load_and_authorize_resource :building

    def index
      @inspections = @building.cooling_tower_inspections.order(inspection_date: :desc).page(params[:page])
    end
  end
end
