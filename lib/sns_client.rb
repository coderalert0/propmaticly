# frozen_string_literal: true

class SnsClient
  attr_reader :client

  def initialize
    @client = Aws::SNS::Client.new(region: 'us-east-2')
  end

  def send_sms(to, body)
    @client.publish({
                      phone_number: to, # Include country code
                      message: body
                    })
  end
end
