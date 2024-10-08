# frozen_string_literal: true

class PortfoliosController < ApplicationController
  load_and_authorize_resource

  def create
    portfolio = Portfolio.new(portfolio_params)
    return unless portfolio.save!

    flash[:success] = t(:portfolio_create_success)
    redirect_to portfolio_buildings_path(portfolio)
  end

  def edit
    render :new
  end

  def update
    return unless @portfolio.update(portfolio_params)

    flash[:success] = t(:portfolio_update_success)
    redirect_to root_path
  end

  def destroy
    return unless @portfolio.buildings.blank?

    return unless @portfolio.destroy

    flash[:success] = t(:portfolio_delete_success)
    redirect_to root_path
  end

  private

  def portfolio_params
    params.require(:portfolio).permit(:name, :description).merge({ organization: current_user.organization })
  end
end
