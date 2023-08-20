# frozen_string_literal: true

class ComplaintsController < ApplicationController
  load_resource

  def index
    @complaints = current_user.organization.complaints.decorate.order(:created_at, :desc)
  end

  def update
    @complaint.update(state: complaint_params[:state].to_i)
    redirect_to complaints_path, notice: 'The status of the complaint has been updated'
  end

  private

  def complaint_params
    params.permit(:id, :state)
  end
end
