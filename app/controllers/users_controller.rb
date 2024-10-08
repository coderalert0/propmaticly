# frozen_string_literal: true

class UsersController < ApplicationController
  load_resource

  def index
    @users = current_user.organization.users.decorate
    @buildings = current_user.organization.buildings
  end

  def update
    ActiveRecord::Base.transaction do
      @user.update(user_params.except(:building_ids))
      BuildingUser.where(user_id: @user.id).destroy_all
      user_params[:building_ids].map { |building_id| BuildingUser.create(user: @user, building_id: building_id) }

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
    params.require(:user).permit(:first_name, :last_name, :sms, :admin, building_ids: [])
  end
end
