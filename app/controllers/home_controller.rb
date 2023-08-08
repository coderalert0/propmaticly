# frozen_string_literal: true

class HomeController < ApplicationController
  def show
    @portfolios = Portfolio.all
  end
end
