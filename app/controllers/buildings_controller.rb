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
    building_details = BuildingHelper.get_building_details(number, street, address.zip5)

    attributes = {
      name: building_params[:name],
      number: number,
      street: street,
      city: address.city,
      state: address.state,
      zip5: address.zip5,
      numerical_properties: building_params[:numerical_properties],
      has_properties: building_params[:has_properties],
      portfolio_id: building_params[:portfolio_id]
    }.merge!(building_details)

    @building.assign_attributes(attributes)

    if @building.save
      @compliance_items_based_on_last_inspection = @building.inspection_rules.select(&:based_on_last_inspection).map(&:compliance_item)
      flash[:success] = @building.persisted? ? t(:building_update_success) : t(:building_create_success)
    end
  rescue StandardError => e
    flash[:danger] = e.message
  end

  alias create save_building
  alias update save_building

  def index
    @buildings = @buildings.includes(:complaints, :violations, :inspections).order(:name).page(params[:page])
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
    params.require(:building).permit(:name, :number, :street, :zip5, :portfolio_id, numerical_properties: {},
                                                                                    has_properties: {}).tap do |whitelisted|
      whitelisted[:has_properties]&.transform_values! { |v| v == '1' }
      whitelisted[:numerical_properties]&.transform_values!(&:to_i)
    end
  end
end
