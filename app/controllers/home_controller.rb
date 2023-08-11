# frozen_string_literal: true

class HomeController < ApplicationController
  def show
    @complaints = current_user.organization.complaints
    @portfolios = Portfolio.all.includes(:buildings)
  end
end
