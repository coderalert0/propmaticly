# frozen_string_literal: true

class InspectionsController < ApplicationController
  load_and_authorize_resource :building

  def index
    @inspections = @building.inspections
  end
end
