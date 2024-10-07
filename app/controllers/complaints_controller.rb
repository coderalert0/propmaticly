# frozen_string_literal: true

class ComplaintsController < ApplicationController
  load_resource
  load_resource :building, only: :index
  load_resource :portfolio, only: :index

  def index
    @complaints = if @building
                    @building.complaints
                  elsif @portfolio
                    @portfolio.complaints
                  else
                    current_user.organization.complaints
                  end
    @complaints = @complaints.send(params[:state]) if params[:state]
    @complaints = @complaints.decorate.order(:created_at, :desc)
  end

  def update
    @complaint.update(state: complaint_params[:state].to_i)
    redirect_to complaints_path, notice: t(:complaint_update_success)
  end

  private

  def complaint_params
    params.permit(:id, :state)
  end
end
