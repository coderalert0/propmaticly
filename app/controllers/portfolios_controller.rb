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
                notice: 'Portfolio added successfully! Now you can add a building to the portfolio to monitor complaints'
  end

  def edit
    render :new
  end

  def update
    redirect_to root_path, notice: 'Portfolio updated successfully' if @portfolio.update(portfolio_params)
  end

  def destroy
    return unless @portfolio.buildings.blank?

    @portfolio.destroy
    redirect_to root_path, notice: 'Portfolio has been deleted successfully'
  end

  private

  def portfolio_params
    params.require(:portfolio)
          .permit(:name, :description)
          .merge({ organization: current_user.organization })
  end
end
