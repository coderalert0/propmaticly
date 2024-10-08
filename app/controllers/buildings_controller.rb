# frozen_string_literal: true

require 'usps'

class BuildingsController < ApplicationController
  load_and_authorize_resource
  load_and_authorize_resource :portfolio

  def index
    @buildings = @buildings.includes(:complaints, :violations)
  end

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
                  notice: t(:building_create_success)
    end
  rescue USPS::InvalidStateError
    flash[:alert] = t(:invalid_state_error)
    redirect_to portfolio_buildings_path(@portfolio)
  rescue StandardError => e
    flash[:alert] = e
    redirect_to portfolio_buildings_path(@portfolio)
  end

  def update
    address = AddressHelper.normalize(building_params[:address1].to_s.strip, building_params[:zip5].strip)
    return unless @building.update(name: building_params[:name],
                                   address1: address.address1,
                                   city: address.city,
                                   state: address.state,
                                   zip5: address.zip5)

    redirect_to portfolio_buildings_path(@portfolio),
                notice: t(:building_update_success)
  rescue StandardError
  end

  def destroy
    return unless @building.complaints.blank?

    @building.destroy
    redirect_to portfolio_buildings_path(@building.portfolio), notice: t(:building_delete_success)
  end

  private

  def building_params
    params.require(:building).permit(:portfolio_id, :name, :address1, :zip5)
  end
end
