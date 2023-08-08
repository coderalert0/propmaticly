# frozen_string_literal: true

class ComplaintsController < ApplicationController
  def index
    @complaints = Complaint.all
  end
end
