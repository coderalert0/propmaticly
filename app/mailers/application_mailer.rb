# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: 'Propmaticly <info@propmaticly.com>'
  layout 'mailer'
end
