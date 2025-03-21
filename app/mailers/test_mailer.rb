# frozen_string_literal: true

class TestMailer < ApplicationMailer
  def test_email
    mail(
      from: 'info@propmaticly.com',
      to: 'gurpreet.dhaliwal@gmail.com',
      subject: 'SMTP Test',
      body: 'This is a test email to verify SMTP configuration.'
    )
  end
end
