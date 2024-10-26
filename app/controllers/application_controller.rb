# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :authenticate_user!, unless: :devise_controller?
  before_action :change_flash_keys, if: :devise_controller?
  skip_before_action :verify_authenticity_token

  def current_organization
    current_user.organization
  end

  private

  def change_flash_keys
    %i[notice alert].each do |key|
      if flash[key]
        flash[:primary] = flash[key]
        flash.delete(key)
      end
    end
  end
end
