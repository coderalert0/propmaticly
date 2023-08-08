# frozen_string_literal: true

require 'usps'

class BuildingsController < ApplicationController
  # load_resource, when cancancan installed
  before_action :load_portfolio, only: %i[index new create]

  def index
    @buildings = @portfolio.buildings
  end

  def new; end

  def create
    USPS.config.username = '1R59PROPM0741'
    address = USPS::Address.new(address1: building_params[:address1].to_s, city: building_params[:city], state: 'CA')
    req = USPS::Request::AddressStandardization.new(address)

    begin
      response = req.send!
      address = response.get(address)

      building = Building.new(name: building_params[:name],
                              address1: address.address1,
                              city: address.city,
                              state: address.state,
                              zip5: address.zip5,
                              email_address: building_params[:email_address],
                              sms: building_params[:sms],
                              portfolio_id: building_params[:portfolio_id])

      redirect_to portfolio_buildings_path(@portfolio), notice: 'Building added successfully!' if building.save!
    rescue StandardError => e
      puts e.inspect
    end
  end

  def edit
    render :new
  end

  private

  def load_portfolio
    # load_resource, when cancancan installed
    @portfolio = Portfolio.find(params[:portfolio_id])
  end

  def building_params
    params.permit(:portfolio_id, :name, :address1, :city, :zip_code, :email_address, :sms)
  end
end
