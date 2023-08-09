# frozen_string_literal: true

class PortfoliosController < ApplicationController
  load_resource :portfolio, only: :update
  def new; end

  def create
    portfolio = Portfolio.new(portfolio_params)
    redirect_to portfolio_buildings_path(portfolio), notice: 'Portfolio added successfully! Now you can add a building to the portfolio to monitor complaints' if portfolio.save!
  end

  def edit
    render :new
  end

  def update
    redirect_to root_path, notice: 'Portfolio updated successfully' if @portfolio.update(portfolio_params)
  end

  private

  def portfolio_params
    params.require(:portfolio).permit(:name, :description, :email_address, :sms)
  end
end
