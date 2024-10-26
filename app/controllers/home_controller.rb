# frozen_string_literal: true

class HomeController < ApplicationController
  def show
    @complaints = current_organization.complaints
    @portfolios = current_organization.portfolios.order(:name).page(params[:page])
    @users = current_organization.users.order('LOWER(first_name)', 'LOWER(last_name)').decorate
    @organization = current_organization
  end
end
