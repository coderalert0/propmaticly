# frozen_string_literal: true

class ViolationNotifierJob < ApplicationJob
  def perform(_violation_id)
    TwilioClient.new.send_sms(User.last, 'A new building violation was filed, click link for details: ' \
      'http://propmatically.com')
  end
end
