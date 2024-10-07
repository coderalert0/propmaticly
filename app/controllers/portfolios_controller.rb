# frozen_string_literal: true

class PortfoliosController < ApplicationController
  load_resource only: %i[update edit destroy]

  def new
    @portfolio = Portfolio.new
  end

  def create
    portfolio = Portfolio.new(portfolio_params)
    return unless portfolio.save!

    redirect_to portfolio_buildings_path(portfolio),
                notice: t(:portfolio_create_success)
  end

  def edit
    render :new
  end

  def update
    redirect_to root_path, notice: t(:portfolio_update_success) if @portfolio.update(portfolio_params)
  end

  def destroy
    return unless @portfolio.buildings.blank?

    @portfolio.destroy
    redirect_to root_path, notice: t(:portfolio_delete_success)
  end

  private

  def portfolio_params
    params.require(:portfolio)
          .permit(:name, :description)
          .merge({ organization: current_user.organization })
  end
end
