# frozen_string_literal: true

class UsersController < ApplicationController
  load_and_authorize_resource
  before_action :validate_admin, only: %i[index destroy]

  def index
    @users = @users.includes(buildings: :portfolio).page(params[:page])
    @users = PaginationDecorator.decorate(@users)
    @portfolios = current_organization.portfolios.order('LOWER(name)')
    @grouped_buildings = current_organization.buildings.includes(:portfolio).group_by(&:portfolio).transform_keys(&:name).transform_values do |buildings|
      buildings.map do |b|
        [b.name, b.id]
      end
    end
  end

  def update
    if @user.update(user_params)
      flash[:success] = t(:user_update_success)
    else
      flash[:danger] = @user.errors.full_messages
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
