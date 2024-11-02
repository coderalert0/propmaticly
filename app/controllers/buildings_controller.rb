# frozen_string_literal: true

require 'usps'

class BuildingsController < ApplicationController
  load_and_authorize_resource
  load_and_authorize_resource :portfolio

  def save_building
    @building = Building.find_or_initialize_by(id: params[:id])

    address = AddressHelper.normalize(
      number: building_params[:number].strip,
      street: building_params[:street].strip,
      zip5: building_params[:zip5].strip
    )

    number, street = address.address1.split(' ', 2)
    bbl_bin = BuildingHelper.get_bbl_bin(number, street, address.zip5)

    attributes = { name: building_params[:name],
                   number: number,
                   street: street,
                   city: address.city,
                   state: address.state,
                   zip5: address.zip5,
                   square_feet: building_params[:square_feet],
                   tax_lot_square_feet: building_params[:tax_lot_square_feet],
                   number_of_stories: building_params[:number_of_stories],
                   boiler_btus: building_params[:boiler_btus],
                   has_elevator: building_params[:has_elevator],
                   has_sprinklers: building_params[:has_sprinklers],
                   has_standpipe: building_params[:has_standpipe],
                   has_backflow: building_params[:has_backflow],
                   has_cooling_tower: building_params[:has_cooling_tower],
                   number_of_residential_units: building_params[:number_of_residential_units],
                   has_gas_piping: building_params[:has_gas_piping],
                   has_units_with_children_under_10: building_params[:has_units_with_children_under_10],
                   portfolio_id: building_params[:portfolio_id] }.merge!(bbl_bin)

    @building.assign_attributes(attributes)

    if @building.save
      flash[:success] = @building.persisted? ? t(:building_update_success) : t(:building_create_success)
    end
  rescue USPS::InvalidStateError
    flash[:danger] = t(:invalid_state_error)
  rescue StandardError => e
    flash[:danger] = e.message
  end

  alias create save_building
  alias update save_building

  def index
    @buildings = @portfolio.buildings
    @buildings = @buildings.order(:name, :asc).page(params[:page])
    @buildings = PaginationDecorator.decorate(@buildings)
  end

  def destroy
    return unless @building.complaints.blank?
    return unless @building.destroy

    flash[:success] = t(:building_delete_success)
    redirect_to portfolio_buildings_path(@building.portfolio)
  end

  private

  def building_params
    params.require(:building).permit(:name, :number, :street, :zip5, :square_feet, :tax_lot_square_feet, :number_of_stories,
                                     :boiler_btus, :has_elevator, :has_sprinklers, :has_standpipe, :has_gas_piping, :has_backflow,
                                     :has_cooling_tower, :number_of_residential_units, :has_units_with_children_under_10,
                                     :portfolio_id)
  end
end
