# frozen_string_literal: true

class ComplaintNotifierJob < ApplicationJob
  def perform(_complaint_id)
    TwilioClient.new.send_sms(User.last, 'A new building complaint was filed, click link for details: ' +
      'http://propmatically.com')
  end
end
