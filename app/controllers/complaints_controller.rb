# frozen_string_literal: true

class ComplaintsController < ApplicationController
  load_and_authorize_resource
  load_and_authorize_resource :building, only: :index
  load_and_authorize_resource :portfolio, only: :index

  def index
    @complaints = @building.complaints
    @complaints = @complaints.send(params[:state]) if params[:state].present?
    binding.break
    if params[:search].present?
      search = "%#{params[:search].strip}%"
      @complaints = @complaints.where('complaint_id LIKE ? OR description LIKE ?', search, search)
    end
    @complaints = @complaints.order(filed_date: :desc).page(params[:page])
    @complaints = PaginationDecorator.decorate(@complaints)
  end

  def create
    complaint = Complaint.new(**create_update_hash)

    return unless complaint.save!

    flash[:success] = t(:complaint_create_success)
    redirect_to building_complaints_path(complaint.building)
  end

  def update
    return unless @complaint.update(create_update_hash)

    flash[:success] = t(:complaint_update_success)
    redirect_to building_complaints_path(@complaint.building)
  end

  def destroy
    return unless @complaint.destroy

    flash[:success] = t(:complaint_delete_success)
    redirect_to building_complaints_path(@complaint.building)
  end

  private

  def complaint_params
    params.require(:complaint).permit(:id, :complaint_id, :state, :filed_date, :description, :category_code, :severity,
                                      :inspection_date, :state, :disposition_date, :disposition_code, :building_id)
  end

  def create_update_hash
    {
      complaint_id: complaint_params[:complaint_id],
      filed_date: complaint_params[:filed_date],
      description: complaint_params[:description],
      category_code: complaint_params[:category_code],
      inspection_date: complaint_params[:inspection_date],
      disposition_date: complaint_params[:disposition_date],
      disposition_code: complaint_params[:disposition_code],
      state: complaint_params[:state],
      severity: complaint_params[:severity],
      building_id: complaint_params[:building_id]
    }
  end
end
