# frozen_string_literal: true

class FetchComplaintsController < ApplicationController
  def show
    Complaints::FetchDobComplaintsJob.perform_later
    Complaints::FetchHpdComplaintsJob.perform_later

    render json: { messages: 'triggering fetch complaints jobs...' }
  end
end
