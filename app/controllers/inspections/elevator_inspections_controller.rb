# frozen_string_literal: true

module Inspections
  class ElevatorsController < ApplicationController
    load_and_authorize_resource :building

    def index
      @inspections = @building.elevator_inspections.order(periodic_latest_inspection: :desc).page(params[:page])
    end
  end
end
