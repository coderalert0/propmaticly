# frozen_string_literal: true

class ComplaintsController < ApplicationController
  load_and_authorize_resource class: 'Complaints::Complaint'
  load_and_authorize_resource :building, only: :index
  load_and_authorize_resource :portfolio, only: :index

  def index
    @complaints = @building.complaints
    @complaints = @complaints.send(params[:state]) if params[:state].present?

    if params[:search].present?
      search = "%#{params[:search].strip}%"
      @complaints = @complaints.where('complaint_id LIKE ? OR description LIKE ?', search, search)
    end
    @complaints = @complaints.order(filed_date: :desc).page(params[:page])
    @complaints = PaginationDecorator.decorate(@complaints)
  end

  def update
    if @complaint.update(complaint_params)
      flash[:success] = t(:complaint_update_success)
    else
      flash[:danger] = @complaint.errors.full_messages
    end
  end

  private

  def complaint_params
    params.require(:complaints_complaint).permit(:resolved_date, :attachments, :audit_comment, :building_id,
                                                 attachments: [])
  end
end
