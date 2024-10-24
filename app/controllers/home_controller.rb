# frozen_string_literal: true

class HomeController < ApplicationController
  def show
    @complaints = current_user.organization.complaints
    @portfolios = current_user.organization.portfolios.order(:name).page(params[:page])
    @users = current_user.organization.users.order('LOWER(first_name)', 'LOWER(last_name)').decorate
  end
end
