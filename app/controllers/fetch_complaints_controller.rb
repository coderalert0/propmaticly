# frozen_string_literal: true

class FetchDobComplaintsController < ApplicationController
  def show
    Delayed::Job.enqueue FetchDOBComplaintsJob.new
    render json: nil
  end
end
