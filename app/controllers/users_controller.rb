# frozen_string_literal: true

class UsersController < ApplicationController
  def index
    @users = current_user.organization.users
  end
end
