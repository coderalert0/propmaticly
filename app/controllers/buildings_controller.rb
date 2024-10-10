# frozen_string_literal: true

require 'usps'

class BuildingsController < ApplicationController
  load_and_authorize_resource
  load_and_authorize_resource :portfolio

  def index
    @buildings = @buildings.includes(:complaints, :violations)
  end

  def create
    address = AddressHelper.normalize({ address1: building_params[:address1].to_s.strip,
                                        zip5: building_params[:zip5].strip })
    building = Building.new(name: building_params[:name],
                            address1: address.address1,
                            city: address.city,
                            state: address.state,
                            zip5: address.zip5,
                            portfolio_id: building_params[:portfolio_id])

    if building.save!
      flash[:success] = t(:building_create_success)
      redirect_to portfolio_buildings_path(building.portfolio)
    end
  rescue USPS::InvalidStateError
    flash[:danger] = t(:invalid_state_error)
    redirect_to portfolio_buildings_path(@portfolio)
  rescue StandardError => e
    flash[:danger] = e
    redirect_to portfolio_buildings_path(@portfolio)
  end

  def update
    address = AddressHelper.normalize(building_params[:address1].to_s.strip, building_params[:zip5].strip)
    return unless @building.update(name: building_params[:name], address1: address.address1, city: address.city,
                                   state: address.state, zip5: address.zip5)

    flash[:success] = t(:building_update_success)
    redirect_to portfolio_buildings_path(@building.portfolio)
  rescue USPS::InvalidStateError
    flash[:danger] = t(:invalid_state_error)
    redirect_to portfolio_buildings_path(@building.portfolio)
  rescue StandardError => e
    flash[:danger] = e
    redirect_to portfolio_buildings_path(@building.portfolio)
  end

  def destroy
    return unless @building.complaints.blank?

    return unless @building.destroy

    flash[:success] = t(:building_delete_success)
    redirect_to portfolio_buildings_path(@building.portfolio)
  end

  private

  def building_params
    params.require(:building).permit(:portfolio_id, :name, :address1, :zip5)
  end
end
