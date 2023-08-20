# frozen_string_literal: true

class UsersController < ApplicationController
  load_resource

  def index
    @users = current_user.organization.users.decorate
  end

  def edit
    @buildings = current_user.organization.buildings
  end

  def update
    ActiveRecord::Base.transaction do
      @user.update(first_name: user_params[:first_name], last_name: user_params[:last_name], sms: user_params[:sms])
      BuildingUser.where(user_id: @user.id).destroy_all
      user_params[:building_ids].map { |building_id| BuildingUser.create(user: @user, building_id: building_id) }

      redirect_to users_path, notice: 'User has been updated successfully'
    end
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :sms, building_ids: [])
  end
end
