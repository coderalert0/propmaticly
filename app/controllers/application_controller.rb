# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :authenticate_user!, unless: :devise_controller?
  skip_before_action :verify_authenticity_token

  def current_organization
    current_user.organization
  end
end
