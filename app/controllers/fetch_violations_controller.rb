# frozen_string_literal: true

class FetchViolationsController < ApplicationController
  def show
    Violations::FetchDobEcbViolationsJob.perform_later
    Violations::FetchDobSafetyViolationsJob.perform_later
    Violations::FetchDobViolationsJob.perform_later
    Violations::FetchHpdViolationsJob.perform_later

    render json: { messages: 'triggering fetch violations jobs...' }
  end
end
