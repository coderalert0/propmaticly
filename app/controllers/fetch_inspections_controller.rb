# frozen_string_literal: true

class FetchInspectionsController < ApplicationController
  def show
    Inspections::FetchBedBugInspectionsJob.perform_later
    Inspections::FetchBoilerInspectionsJob.perform_later
    Inspections::FetchCoolingTowerInspectionsJob.perform_later
    Inspections::FetchElevatorInspectionsJob.perform_later
    Inspections::FetchFacadeInspectionsJob.perform_later

    CreateUpcomingInspectionsJob.perform_later

    render json: { messages: 'triggering fetch inspection jobs...' }
  end
end
