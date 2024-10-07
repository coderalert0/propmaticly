# frozen_string_literal: true

class FetchViolationsController < ApplicationController
  def show
    Delayed::Job.enqueue FetchViolationsJob.new
    render json: nil
  end
end
