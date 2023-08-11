# frozen_string_literal: true

require 'usps'

class BuildingsController < ApplicationController
  load_resource only: %i[index new edit update]
  load_resource :portfolio, only: %i[new edit update create]

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
                              portfolio_id: building_params[:portfolio_id])

      if building.save!
        redirect_to portfolio_buildings_path(@portfolio),
                    notice: 'Building added successfully! We are now monitoring it for any complaints'
      end
    rescue StandardError => e
      puts e.inspect
    end
  end

  def update
    return unless @building.update(building_params)

    redirect_to portfolio_buildings_path(@portfolio),
                notice: 'Building updated successfully'
  end

  private

  def building_params
    params.require(:building).permit(:portfolio_id, :name, :address1, :city, :zip5)
  end
end
