# frozen_string_literal: true

class ComplaintsController < ApplicationController
  load_and_authorize_resource
  load_and_authorize_resource :building
  load_and_authorize_resource :portfolio, only: :index

  def index
    if @building
      @complaints = @building.complaints
    elsif @portfolio
      @complaints = @portfolio.complaints
    end

    @complaints = @complaints.send(params[:state]) if params[:state]
    @complaints = @complaints.decorate.order(:created_at, :desc)
  end

  def create
    complaint = Complaint.new(complaint_id: complaint_params[:complaint_id],
                              filed_date: complaint_params[:filed_date],
                              description: complaint_params[:description],
                              category: complaint_params[:category],
                              last_inspection_date: complaint_params[:last_inspection_date],
                              last_inspection_result: complaint_params[:last_inspection_result],
                              disposition_date: complaint_params[:disposition_date],
                              state: complaint_params[:state],
                              building_id: complaint_params[:building_id])

    return unless complaint.save!

    flash[:success] = t(:complaint_create_success)
    redirect_to building_complaints_path(complaint.building)
  end

  def update
    if @complaint.update(complaint_id: complaint_params[:complaint_id],
                         filed_date: complaint_params[:filed_date],
                         description: complaint_params[:description],
                         category: complaint_params[:category],
                         last_inspection_date: complaint_params[:last_inspection_date],
                         last_inspection_result: complaint_params[:last_inspection_result],
                         disposition_date: complaint_params[:disposition_date],
                         state: complaint_params[:state],
                         building_id: complaint_params[:building_id])

      flash[:success] = t(:complaint_update_success)
      redirect_to building_complaints_path(@complaint.building)
    end
  end

  def destroy
    return unless @complaint.destroy

    flash[:success] = t(:complaint_delete_success)
    redirect_to building_complaints_path(@complaint.building)
  end

  private

  def complaint_params
    params.require(:complaint).permit(:id, :complaint_id, :state, :filed_date, :description, :category,
                                      :last_inspection_date, :last_inspection_result, :state, :building_id, :disposition_date)
  end
end
