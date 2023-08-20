# frozen_string_literal: true

class HomeController < ApplicationController
  def show
    @complaints = current_user.organization.complaints
    @portfolios = current_user.organization.portfolios.includes(:buildings).order(:name)
  end
end
