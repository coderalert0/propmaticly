# frozen_string_literal: true

class PortfoliosController < ApplicationController
  load_and_authorize_resource

  def create
    ActiveRecord::Base.transaction do
      portfolio = Portfolio.new(portfolio_params)

      if portfolio.save
        portfolio.update_asset_contacts(params[:portfolio][:user_ids])
        flash[:success] = t(:portfolio_create_success)
        redirect_to portfolio_buildings_path(portfolio)
      else
        render :new
      end
    end
  end

  def edit
    render :new
  end

  def update
    ActiveRecord::Base.transaction do
      if @portfolio.update(portfolio_params)
        @portfolio.update_asset_contacts(params[:portfolio][:user_ids])
        flash[:success] = t(:portfolio_update_success)
        redirect_to root_path
      else
        render :edit
      end
    end
  end

  def destroy
    return unless @portfolio.buildings.blank?

    return unless @portfolio.destroy

    flash[:success] = t(:portfolio_delete_success)
    redirect_to root_path
  end

  private

  def portfolio_params
    params.require(:portfolio).permit(:name, :description, :user_id).merge({ organization: current_user.organization })
  end
end
