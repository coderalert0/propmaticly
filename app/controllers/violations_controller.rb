# frozen_string_literal: true

class ViolationsController < ApplicationController
  load_and_authorize_resource class: 'Violations::Violation'
  load_and_authorize_resource :building, only: :index
  load_and_authorize_resource :portfolio, only: :index

  def index
    @violations = @building.violations
    @violations = @violations.send(params[:state]) if params[:state].present?
    if params[:search].present?
      search = "%#{params[:search].strip}%"
      @violations = @violations.where('violation_id LIKE ? OR description LIKE ?', search, search)
    end
    @violations = @violations.order(issue_date: :desc).page(params[:page])
    @violations = PaginationDecorator.decorate(@violations)
  end

  def update
    modifiable_params = violation_params.dup

    modifiable_params[:resolved_date] = nil unless modifiable_params[:state] == 'closed'

    if @violation.update(modifiable_params)
      flash[:success] = t(:violation_update_success)
    else
      flash[:danger] = @violation.errors.full_messages
    end
  end

  private

  def violation_params
    params.require(:violations_violation).permit(:state, :resolved_date, :attachments, :audit_comment, :building_id,
                                                 attachments: [])
  end
end
