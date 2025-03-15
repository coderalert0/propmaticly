# frozen_string_literal: true

class UsersController < ApplicationController
  load_resource
  before_action :validate_admin

  def index
    @users = current_organization.users.page(params[:page])
    @users = PaginationDecorator.decorate(@users)
    @portfolios = current_organization.portfolios.order('LOWER(name)')
    @grouped_buildings = current_organization.buildings.group_by(&:portfolio).transform_keys(&:name).transform_values do |buildings|
      buildings.map do |b|
        [b.name, b.id]
      end
    end
  end

  def update
    ActiveRecord::Base.transaction do
      @user.update(user_params.except(:portfolio_ids, :building_ids))
      AssetContact.assign_assets_to_user('Portfolio', user_params[:portfolio_ids], @user)
      AssetContact.assign_assets_to_user('Building', user_params[:building_ids], @user)
      flash[:success] = t(:user_update_success)
      redirect_to users_path
    end
  end

  def destroy
    return unless @user.destroy

    flash[:success] = t(:user_delete_success)
    redirect_to users_path
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :sms, :title, :admin, portfolio_ids: [], building_ids: [])
  end

  def validate_admin
    return if current_user.admin?

    flash[:danger] = t(:no_permission)
    redirect_to root_path
  end
end
