# frozen_string_literal: true

class PortfoliosController < ApplicationController
  def new; end

  def create
    portfolio = Portfolio.new(portfolio_params)
    redirect_to root_path, notice: 'Portfolio added successfully!' if portfolio.save!
  end

  def edit
    render :new
  end

  private

  def portfolio_params
    params.permit(:name, :description, :email_address, :sms)
  end
end
