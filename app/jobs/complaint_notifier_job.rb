# frozen_string_literal: true

class ComplaintNotifierJob < ApplicationJob
  def perform(_complaint_id)
    puts '*** in the notifier job'
  end
end
