class FetchComplaintsController < ApplicationController
  def show
    Delayed::Job.enqueue FetchComplaintsJob.new
    render json: nil
  end
end