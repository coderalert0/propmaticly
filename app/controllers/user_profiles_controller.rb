# frozen_string_literal: true

class UserProfilesController < ApplicationController
  load_resource class: 'User', instance_name: :user

  def update
    if @user.update(user_profile_params)
      flash[:success] = t(:user_profile_update_success)
    else
      flash[:danger] = @user.errors.full_messages
    end
  end

  private

  def user_profile_params
    params.require(:user).permit(:first_name, :last_name, :sms, :title)
  end
end
