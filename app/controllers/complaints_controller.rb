# frozen_string_literal: true

class ComplaintsController < ApplicationController
  def index
    @complaints = current_user.organization.complaints.decorate.order(:created_at, :desc)
  end

  def update

  end
end
