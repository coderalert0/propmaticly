# frozen_string_literal: true

require 'faraday'

class FetchLeadsJob < ApplicationJob
  def perform
    beginning_of_year = Date.today.beginning_of_year.strftime('%Y-%m-%d')
    url = 'https://data.cityofnewyork.us/resource/6bgk-3dad.json'
    params = {
      :$where => "issue_date > '#{beginning_of_year}' AND penality_imposed > 3000",
      :$limit => 10_000
    }

    response = safe_faraday_get(url, params)
    return unless response && response.status == 200

    JSON.parse(response.body).each do |resource|
      process_resource(resource)
    end
  end

  private

  def process_resource(resource)
    corporation = fetch_corporation_info(resource['respondent_name'])

    if corporation.present?
      address        = corporation['dos_process_address_1']
      city           = corporation['dos_process_city']
      state          = corporation['dos_process_state']
      zip_code       = corporation['dos_process_zip']
      chairman_name  = corporation['chairman_name']
      process_name   = corporation['dos_process_name']
      agent_name     = corporation['registered_agent_name']
      agent_address  = corporation['registered_agent_address_1']
      agent_city     = corporation['registered_agent_city']
      agent_state    = corporation['registered_agent_state']
      agent_zip_code = corporation['registered_agent_zip']
    else
      address        = "#{resource['respondent_house_number']} #{resource['respondent_street']}"
      city           = resource['respondent_city']
      state          = nil
      zip_code       = resource['respondent_zip']
      chairman_name  = nil
      process_name   = nil
      agent_name     = nil
      agent_address  = nil
      agent_city     = nil
      agent_state    = nil
      agent_zip_code = nil
    end

    resource_attributes = {
      chairman_name: chairman_name,
      process_name: process_name,
      process_address: address,
      process_city: city,
      process_state: state,
      process_zip_code: zip_code,
      agent_name: agent_name,
      agent_address: agent_address,
      agent_city: agent_city,
      agent_state: agent_state,
      agent_zip_code: agent_zip_code,
      issue_date: resource['issue_date'],
      penalty_imposed: resource['penality_imposed'],
      amount_paid: resource['amount_paid'],
      balance_due: resource['balance_due']
    }

    resource_unique_params = {
      entity_name: resource['respondent_name'],
      ecb_violation_number: resource['ecb_violation_number']
    }

    lead = Lead.find_or_initialize_by(resource_unique_params)
    lead.update(resource_attributes) if lead.new_record?
  end

  def fetch_corporation_info(name)
    url = 'https://data.ny.gov/resource/n9v6-gdp6.json'
    params = {
      :$where => "current_entity_name = '#{name}' OR dos_process_name = '#{name}'",
      :$limit => 1
    }

    response = safe_faraday_get(url, params)
    return unless response && response.status == 200

    JSON.parse(response.body).first
  end

  def safe_faraday_get(url, params)
    Faraday.get(url, params)
  rescue Faraday::Error => e
    Rails.logger.error "FetchLeadsJob Faraday error for URL #{url}: #{e.message}"
    nil
  end
end
