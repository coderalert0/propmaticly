# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: 'info@propmaticly.com'
  layout 'mailer'
end
