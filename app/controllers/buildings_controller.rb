# frozen_string_literal: true

require 'usps'

class BuildingsController < ApplicationController
  load_and_authorize_resource
  load_and_authorize_resource :portfolio

  def index
    @buildings = @portfolio.buildings
    @buildings = @buildings.order(:name, :asc).page(params[:page])
    @buildings = PaginationDecorator.decorate(@buildings)
  end

  def create
    address = AddressHelper.normalize({ number: building_params[:number].strip, street: building_params[:street].strip,
                                        zip5: building_params[:zip5].strip })

    number, street = address.address1.split(' ', 2)

    building = Building.new(name: building_params[:name],
                            number: number,
                            street: street,
                            city: address.city,
                            state: address.state,
                            zip5: address.zip5,
                            portfolio_id: building_params[:portfolio_id])

    flash[:success] = t(:building_create_success) if building.save!
  rescue USPS::InvalidStateError
    flash[:danger] = I18n.t(:invalid_state_error)
  rescue StandardError => e
    flash[:danger] = e
  end

  def update
    address = AddressHelper.normalize({ number: building_params[:number].strip, street: building_params[:street].strip,
                                        zip5: building_params[:zip5].strip })

    number, street = address.address1.split(' ', 2)

    return unless @building.update(name: building_params[:name], number: number, street: street, city: address.city,
                                   state: address.state, zip5: address.zip5)

    flash[:success] = t(:building_update_success)
  rescue USPS::InvalidStateError
    flash[:danger] = I18n.t(:invalid_state_error)
  rescue StandardError => e
    flash[:danger] = e
  end

  def destroy
    return unless @building.complaints.blank?

    return unless @building.destroy

    flash[:success] = t(:building_delete_success)
    redirect_to portfolio_buildings_path(@building.portfolio)
  end

  private

  def building_params
    params.require(:building).permit(:name, :number, :street, :zip5, :portfolio_id)
  end
end
