# frozen_string_literal: true

class UsersController < ApplicationController
  def index
    @users = current_user.organization.users.decorate
  end
end
