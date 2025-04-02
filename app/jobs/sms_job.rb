# frozen_string_literal: true

class SmsJob < ApplicationJob
  def perform(sms, message)
    SnsClient.new.send_sms(sms, message)
  rescue StandardError => e
    Rails.logger.error "Failed to send SMS to user #{user_id}: #{e.message}"
  end
end
