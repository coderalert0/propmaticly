# frozen_string_literal: true

class UsersController < ApplicationController
  load_resource
  before_action :validate_admin

  def index
    @users = current_user.organization.users.page(params[:page])
    @users = PaginationDecorator.decorate(@users)
    @buildings = current_user.organization.buildings
  end

  def update
    ActiveRecord::Base.transaction do
      @user.update(user_params.except(:building_ids))
      AssetContact.where(user_id: @user.id, assignable_type: 'Building').destroy_all
      user_params[:building_ids]&.each do |building_id|
        AssetContact.create(user: @user, assignable: Building.find(building_id))
      end

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

  def validate_admin
    return if current_user.admin?

    flash[:danger] = t(:no_permission)
    redirect_to root_path
  end
end
