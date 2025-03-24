# frozen_string_literal: true

class LeadsController < ApplicationController
  load_resource

  def index
    if params[:search].present?
      search = "%#{params[:search].strip}%"
      @leads = @leads.where('entity_name LIKE ?', search)
    end

    @leads = grouped_leads
    @leads = @leads.order(total_penalty_imposed: :desc).page(params[:page]).per(20)
  end

  def generate_pdf
    @leads = Lead.all
    @leads = grouped_leads
    respond_to do |format|
      format.pdf do
        render pdf: 'output',
               template: 'leads/pdf',
               formats: [:html],  # instruct Rails to use the HTML template
               layout: 'pdf'      # if you're using a PDF-specific layout
      end
    end
  end

  def grouped_leads
    @leads = @leads.group(:entity_name)
                   .select(
                     'entity_name,
MAX(chairman_name) AS chairman_name,
MAX(process_name) AS process_name,
                      MAX(process_address) AS process_address,
                      MAX(process_city) AS process_city,
                      MAX(process_state) AS process_state,
                      MAX(process_zip_code) AS process_zip_code,
MAX(agent_name) AS agent_name,
                      MAX(agent_address) AS agent_address,
                      MAX(agent_city) AS agent_city,
                      MAX(agent_state) AS agent_state,
                      MAX(agent_zip_code) AS agent_zip_code,
                      MAX(ecb_violation_number) AS ecb_violation_number,
                      MAX(issue_date) AS issue_date,
                      SUM(penalty_imposed) AS total_penalty_imposed,
                      SUM(amount_paid) AS total_amount_paid,
                      SUM(balance_due) AS total_balance_due'
                   )
  end
end
