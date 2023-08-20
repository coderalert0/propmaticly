# frozen_string_literal: true

require 'usps'

class BuildingsController < ApplicationController
  load_resource
  load_resource :portfolio

  def create
    address = AddressHelper.normalize(building_params[:address1].to_s.strip, building_params[:zip5].strip)
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

  def update
    address = AddressHelper.normalize(building_params[:address1].to_s.strip, building_params[:zip5].strip)
    return unless @building.update(name: building_params[:name],
                                   address1: address.address1,
                                   city: address.city,
                                   state: address.state,
                                   zip5: address.zip5)

    redirect_to portfolio_buildings_path(@portfolio),
                notice: 'Building updated successfully'
  end

  def destroy
    return unless @building.complaints.blank?

    @building.destroy
    redirect_to portfolio_path(@building.portfolio), notice: 'Building has been deleted successfully'
  end

  private

  def building_params
    params.require(:building).permit(:portfolio_id, :name, :address1, :zip5)
  end
end
