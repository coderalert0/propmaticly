# frozen_string_literal: true

require 'rqrcode'
require 'amatch'

class LeadsController < ApplicationController
  load_and_authorize_resource

  def index
    if params[:search].present?
      search = "%#{params[:search].strip.downcase}%"
      @leads = @leads.where('LOWER(entity_name) LIKE ?', search)
    end

    @leads = fuzzy_grouped_leads
    @leads = @leads.sort_by { |lead| -lead.total_penalty_imposed }
    @leads = Kaminari.paginate_array(@leads).page(params[:page]).per(20)
  end

  def generate_pdf
    @leads = Lead.all
    @leads = fuzzy_grouped_leads

    @qr_codes = @leads.each_with_object({}) do |lead, hash|
      sanitized_entity_name = lead.entity_name.titleize.delete('^a-zA-Z0-9 ')
      total_penalty = ActionController::Base.helpers.number_to_currency(lead.total_penalty_imposed)

      url = "https://propmaticly.com?entity_name=#{sanitized_entity_name}&total_penalty=#{total_penalty}"
      hash[lead.entity_name] = RQRCode::QRCode.new(url)
    end

    respond_to do |format|
      format.pdf do
        render pdf: 'output',
               template: 'leads/pdf',
               formats: [:html],
               layout: 'pdf'
      end
    end
  end

  private

  def fuzzy_grouped_leads
    leads = @leads.to_a
    grouped = {}

    leads.each do |lead|
      match_found = false
      grouped.each do |key, group|
        next unless fuzzy_match(key, lead.entity_name)

        group << lead
        match_found = true
        break
      end

      grouped[lead.entity_name] = [lead] unless match_found
    end

    grouped.map do |entity_name, group|
      aggregate_lead_data(entity_name, group)
    end
  end

  def fuzzy_match(str1, str2, threshold = 0.9)
    matcher = Amatch::JaroWinkler.new(str1)
    matcher.match(str2) >= threshold
  end

  def aggregate_lead_data(entity_name, leads)
    OpenStruct.new(
      entity_name: entity_name,
      chairman_name: leads.map(&:chairman_name).compact.first,
      process_name: leads.map(&:process_name).compact.first,
      process_address: leads.map(&:process_address).compact.first,
      process_city: leads.map(&:process_city).compact.first,
      process_state: leads.map(&:process_state).compact.first,
      process_zip_code: leads.map(&:process_zip_code).compact.first,
      agent_name: leads.map(&:agent_name).compact.first,
      agent_address: leads.map(&:agent_address).compact.first,
      agent_city: leads.map(&:agent_city).compact.first,
      agent_state: leads.map(&:agent_state).compact.first,
      agent_zip_code: leads.map(&:agent_zip_code).compact.first,
      ecb_violation_number: leads.map(&:ecb_violation_number).compact.first,
      issue_date: leads.map(&:issue_date).compact.first,
      total_penalty_imposed: leads.sum(&:penalty_imposed),
      total_amount_paid: leads.sum(&:amount_paid),
      total_balance_due: leads.sum(&:balance_due)
    )
  end
end
